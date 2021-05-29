{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module FataMorgana (fataMorgana) where

import FataMorgana.ArgParser (Fata (..), fata)
import FataMorgana.Internal
import Data.Foldable (traverse_)
import Data.Yaml (decodeFileEither)
import System.Process (callCommand)

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
