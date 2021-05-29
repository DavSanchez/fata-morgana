{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module FataMorgana (fataMorgana) where

import ArgParser (Fata (..), fata)
import Data.Foldable (traverse_)
import Data.Yaml (FromJSON, decodeFileEither)
import GHC.Generics (Generic)
import System.Process (callCommand)

newtype Config = Config
  { registry_url :: String
  }
  deriving (Generic)

instance FromJSON Config

fataMorgana :: IO ()
fataMorgana = do
  args <- fata
  conf <- decodeFileEither "./mirror-config.yaml"
  either
    (errorWithoutStackTrace "Error: could not read or parse mirror-config.yaml file.")
    (`mirrorImage` args)
    conf

mirrorImage :: Config -> Fata -> IO ()
mirrorImage c f = traverse_ callCommand $ commandList c f

commandList :: Config -> Fata -> [String]
commandList c f = [dockerPull, dockerTag, dockerPush]
  where
    dockerPull = "docker pull " <> oldUrl
    dockerTag = "docker tag " <> oldUrl <> " " <> newUrl
    dockerPush = "docker push " <> newUrl
    oldUrl = baseUrlSegment (url f) <> img f <> tagSegment (tag f)
    newUrl = registry_url c <> "/" <> img f <> tagSegment (tag f)

baseUrlSegment :: String -> String
baseUrlSegment "" = ""
baseUrlSegment u = u <> "/"

tagSegment :: String -> String
tagSegment "" = ""
tagSegment t = ":" <> t
