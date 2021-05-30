module Main (main) where

import Control.Exception (evaluate)
import FataMorgana.Internal
  ( Command,
    Config (..),
    baseUrlSegment,
    commandList,
    imageTagSegment,
  )
import FataMorgana.Mirager (Mirage (Mirage), URL)
import Test.Hspec
  ( anyException,
    describe,
    hspec,
    it,
    shouldBe,
    shouldThrow,
  )

main :: IO ()
main = hspec $ do
  describe "URL segment" $ do
    it "should create a segment appending '/' when necessary" $ do
      baseUrlSegment "" `shouldBe` ""
      baseUrlSegment "/" `shouldBe` ""
      baseUrlSegment (registry_url testConfig) `shouldBe` testConfigWithSlash
      baseUrlSegment testConfigWithSlash `shouldBe` testConfigWithSlash

  describe "Image and tag pair" $ do
    it "should create a legal image[:tag] pair" $ do
      imageTagSegment "example-image" "" `shouldBe` "example-image"
      imageTagSegment "example-image" " " `shouldBe` "example-image"
      imageTagSegment "example-image" "v0.1.0" `shouldBe` "example-image:v0.1.0"

    it "should throw error if the image name is empty" $ do
      evaluate (imageTagSegment "" "") `shouldThrow` anyException
      evaluate (imageTagSegment " " "") `shouldThrow` anyException

  describe "The command list" $ do
    it "should represent the configuration passed" $ do
      commandList testConfig testMirageBase `shouldBe` expectedCommandListBase
      commandList testConfig testMirageTag `shouldBe` expectedCommandListTag
      commandList testConfig testMirageURL `shouldBe` expectedCommandListWithOrigin
      commandList testConfig testMirageUrlTag `shouldBe` expectedCommandListWithOriginTag
      commandList testConfig testMirageUrlTagSlash `shouldBe` expectedCommandListWithOriginTag

testConfig :: Config
testConfig = Config "registry.destination.com/project"

testConfigWithSlash :: URL
testConfigWithSlash = registry_url testConfig <> "/"

testOriginRegistry :: URL
testOriginRegistry = "registry.origin.com/project"

testOriginRegistryWithSlash :: URL
testOriginRegistryWithSlash = "registry.origin.com/project/"

testMirageBase :: Mirage
testMirageBase = Mirage "" "example-image" ""

testMirageURL :: Mirage
testMirageURL = Mirage testOriginRegistry "example-image" ""

testMirageTag :: Mirage
testMirageTag = Mirage "" "example-image" "tag"

testMirageUrlTag :: Mirage
testMirageUrlTag = Mirage testOriginRegistryWithSlash "example-image/" "tag"

testMirageUrlTagSlash :: Mirage
testMirageUrlTagSlash = Mirage testOriginRegistryWithSlash "example-image" "tag/"

expectedCommandListBase :: [Command]
expectedCommandListBase =
  [ "docker pull " <> "example-image",
    "docker tag " <> "example-image " <> testConfigWithSlash <> "example-image",
    "docker push " <> testConfigWithSlash <> "example-image"
  ]

expectedCommandListTag :: [Command]
expectedCommandListTag =
  [ "docker pull " <> "example-image:tag",
    "docker tag " <> "example-image:tag " <> testConfigWithSlash <> "example-image:tag",
    "docker push " <> testConfigWithSlash <> "example-image:tag"
  ]

expectedCommandListWithOrigin :: [Command]
expectedCommandListWithOrigin =
  [ "docker pull " <> testOriginRegistryWithSlash <> "example-image",
    "docker tag " <> testOriginRegistryWithSlash <> "example-image" <> " " <> testConfigWithSlash <> "example-image",
    "docker push " <> testConfigWithSlash <> "example-image"
  ]

expectedCommandListWithOriginTag :: [Command]
expectedCommandListWithOriginTag =
  [ "docker pull " <> testOriginRegistryWithSlash <> "example-image:tag",
    "docker tag " <> testOriginRegistryWithSlash <> "example-image:tag" <> " " <> testConfigWithSlash <> "example-image:tag",
    "docker push " <> testConfigWithSlash <> "example-image:tag"
  ]
