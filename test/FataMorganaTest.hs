module Main (main) where

import Control.Exception (evaluate)
import FataMorgana.ArgParser
import FataMorgana.Internal
import Test.Hspec
import Test.QuickCheck

testConfig :: String
testConfig = "registry.example.com/project"

testFata :: Fata
testFata =
  Fata
    { url = "",
      img = "example-image",
      tag = ""
    }

main :: IO ()
main = hspec $ do
  describe "URL segment" $ do
    it "Should create a segment appending '/'" $ do
      baseUrlSegment "" `shouldBe` ""

    it "returns the first element of an *arbitrary* list" $
      property $ \x xs -> head (x : xs) == (x :: Int)

    it "throws an exception if used with an empty list" $ do
      evaluate (head []) `shouldThrow` anyException

-- main :: IO ()
-- main = putStrLn "Test suite not yet implemented."
{-
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
-}
