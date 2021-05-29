{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ViewPatterns #-}

module FataMorgana.Internal where

import Data.Yaml (FromJSON)
import FataMorgana.ArgParser (Fata (img, tag, url), ImageName, Tag, URL)
import GHC.Generics (Generic)

type Command = String

newtype Config = Config
  { registry_url :: URL
  }
  deriving (Generic)

instance FromJSON Config

commandList :: Config -> Fata -> [Command]
commandList c f = [dockerPull, dockerTag, dockerPush]
  where
    dockerPull = "docker pull " <> oldUrl
    dockerTag = "docker tag " <> oldUrl <> " " <> newUrl
    dockerPush = "docker push " <> newUrl
    oldUrl = baseUrlSegment (url f) <> imageTagSegment (img f) (tag f)
    newUrl = baseUrlSegment (registry_url c) <> imageTagSegment (img f) (tag f)

baseUrlSegment :: URL -> URL
baseUrlSegment [] = []
baseUrlSegment u@(last -> '/') = u
baseUrlSegment u = u <> "/"

imageTagSegment :: ImageName -> Tag -> ImageName
imageTagSegment i [] = i
imageTagSegment i t = i <> ":" <> t