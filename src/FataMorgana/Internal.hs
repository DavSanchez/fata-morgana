{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module FataMorgana.Internal where

import FataMorgana.ArgParser
import Data.Yaml (FromJSON)
import GHC.Generics (Generic)

newtype Config = Config
  { registry_url :: String
  }
  deriving (Generic)

instance FromJSON Config

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