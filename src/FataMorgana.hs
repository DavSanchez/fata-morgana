module FataMorgana (fata) where

import Options.Applicative
import Data.Semigroup ((<>))

data Fata = Fata {
  url :: String,
  image :: String,
  tag :: String
}

fataArgs :: Parser Fata
fataArgs = undefined 

fata :: IO ()
fata = putStrLn "someFunc"
