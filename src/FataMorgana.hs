{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module FataMorgana (fataMorgana) where

import ArgParser (Fata (Fata), fata)
import Data.Semigroup ((<>))
import Data.Yaml (FromJSON, ParseException, decodeFileEither)
import GHC.Generics (Generic)
import System.Process (callCommand)

newtype Config = Config
  { harbor_url :: String
  }
  deriving (Generic)

instance FromJSON Config

fataMorgana :: IO ()
fataMorgana = do
  args <- fata
  conf <- decodeFileEither "./harbor.yaml"
  case conf of
    Right c -> mirrorImage c args
    Left _ -> error "Could not read config.yaml file"

mirrorImage :: Config -> Fata -> IO ()
mirrorImage c (Fata u img t) = do
  callCommand $ "docker pull " <> oldUrl
  callCommand $ "docker tag " <> oldUrl <> " " <> newUrl
  callCommand $ "docker push " <> newUrl
  where
    url = buildUrlSegment u
    tag = buildTagSegment t
    oldUrl = url <> img <> tag
    newUrl = harbor_url c <> "/" <> img <> tag

buildUrlSegment :: String -> String
buildUrlSegment "" = ""
buildUrlSegment u = u <> "/"

buildTagSegment :: String -> String
buildTagSegment "" = ""
buildTagSegment t = ":" <> t
