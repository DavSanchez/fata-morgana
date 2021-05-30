module FataMorgana.Mirager (Mirage (..), URL, ImageName, Tag, mirage) where

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

type URL = String

type ImageName = String

type Tag = String

data Mirage = Mirage
  { url :: URL,
    img :: ImageName,
    tag :: Tag
  }

mirageArgs :: Parser Mirage
mirageArgs =
  Mirage
    <$> strOption
      ( long "url"
          <> short 'u'
          <> metavar "BASE_URL"
          <> value ""
          <> help "Base URL for getting the image. When unset it uses Docker default behavior."
      )
    <*> strOption
      ( long "image"
          <> short 'i'
          <> metavar "IMAGE"
          <> help "Image name. Required."
      )
    <*> strOption
      ( long "tag"
          <> short 't'
          <> metavar "TAG"
          <> value ""
          <> help "Tag. When unset it uses Docker default behavior."
      )

mirage :: IO Mirage
mirage =
  execParser $
    info
      (mirageArgs <**> helper)
      ( fullDesc
          <> progDesc "Mirrors IMAGE[:TAG] from BASE_URL (or the Docker default) to a pre-defined registry."
          <> header "Fata Morgana - Mirror images between container registries."
      )
