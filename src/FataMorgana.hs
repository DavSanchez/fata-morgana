{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module FataMorgana (fataMorgana) where

import ArgParser (Fata (..), fata)
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
mirrorImage c f = do
  callCommand $ "docker pull " <> oldUrl
  callCommand $ "docker tag " <> oldUrl <> " " <> newUrl
  callCommand $ "docker push " <> newUrl
  where
    urlSegment = buildUrlSegment $ url f
    tagSegment = buildTagSegment $ tag f
    oldUrl = urlSegment <> img f <> tagSegment
    newUrl = harbor_url c <> "/" <> img f <> tagSegment

buildUrlSegment :: String -> String
buildUrlSegment "" = ""
buildUrlSegment u = u <> "/"

buildTagSegment :: String -> String
buildTagSegment "" = ""
buildTagSegment t = ":" <> t
