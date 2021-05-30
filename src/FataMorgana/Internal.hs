{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ViewPatterns #-}

module FataMorgana.Internal where

import Data.Char (isSpace)
import Data.Yaml (FromJSON)
import FataMorgana.Mirager (ImageName, Mirage (img, tag, url), Tag, URL)
import GHC.Generics (Generic)

type Command = String

newtype Config = Config
  { registry_url :: URL
  }
  deriving (Generic)

instance FromJSON Config

commandList :: Config -> Mirage -> [Command]
commandList c f = [dockerPull, dockerTag, dockerPush]
  where
    dockerPull = "docker pull " <> oldUrl
    dockerTag = "docker tag " <> oldUrl <> " " <> newUrl
    dockerPush = "docker push " <> newUrl
    oldUrl = baseUrlSegment (url f) <> imageTagSegment (img f) (tag f)
    newUrl = baseUrlSegment (registry_url c) <> imageTagSegment (img f) (tag f)

baseUrlSegment :: URL -> URL
baseUrlSegment [] = []
baseUrlSegment "/" = []
baseUrlSegment u@(last -> '/') = u
baseUrlSegment u = u <> "/"

imageTagSegment :: ImageName -> Tag -> ImageName
imageTagSegment [] _ = error "Image name cannot be empty."
imageTagSegment (processField -> []) _ = imageTagSegment [] []
imageTagSegment i (processField -> []) = processField i
imageTagSegment i t = mconcat $ processField <$> [i, ":", t]

processField :: String -> String
processField = removeTrailingSlash . filterOutSpace

filterOutSpace :: String -> String
filterOutSpace = filter (not . isSpace)

removeTrailingSlash :: String -> String
removeTrailingSlash [] = []
removeTrailingSlash x@(last -> '/') = init x
removeTrailingSlash x = x