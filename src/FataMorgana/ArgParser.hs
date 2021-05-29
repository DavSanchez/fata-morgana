module FataMorgana.ArgParser (Fata (..), fata) where

import Options.Applicative
  ( Parser,
    execParser,
    fullDesc,
    header,
    help,
    helper,
    info,
    long,
    metavar,
    progDesc,
    short,
    strOption,
    value,
    (<**>),
  )

data Fata = Fata
  { url :: String,
    img :: String,
    tag :: String
  }

fataArgs :: Parser Fata
fataArgs =
  Fata
    <$> strOption
      ( long "url"
          <> short 'u'
          <> metavar "BASE_URL"
          <> value ""
          <> help "Base URL for getting the image. Leave it blank to use default."
      )
    <*> strOption
      ( long "image"
          <> short 'i'
          <> metavar "IMAGE"
          <> help "Image name."
      )
    <*> strOption
      ( long "tag"
          <> short 't'
          <> metavar "TAG"
          <> value ""
          <> help "Tag. You can leave this blank."
      )

fata :: IO Fata
fata =
  execParser $
    info
      (fataArgs <**> helper)
      ( fullDesc
          <> progDesc "Mirror IMAGE[:TAG] from BASE_URL to a pre-defined registry"
          <> header "Fata Morgana - Mirror images between container registries"
      )