#  Fata Morgana

[![Language: Haskell](https://img.shields.io/badge/Language-Haskell-blueviolet)](https://img.shields.io/badge/Language-Haskell-blueviolet) [![CI](https://github.com/DavSanchez/fata-morgana/actions/workflows/ci.yml/badge.svg)](https://github.com/DavSanchez/fata-morgana/actions/workflows/ci.yml)

Original repo (and binaries) are available at [GitHub](https://github.com/DavSanchez/fata-morgana).

> ##  Mirror Image
>
> This spell grabs 1-4 duplicates of the caster from near-identical timelines to confuse foes [...]. Since all of the mirror images are the caster, in the same situation and fighting the same battle in their own timeline, they are indistinguishable in every way from the caster and mimic his every motion...
>
> *— A certaing magical effect description from a certain roleplaying game.*

This is just a little toy project to address some FDP chores. An accomplished *Mirager*, Fata Morgana conjures an image from some container registry and materializes it in the heights of Cloud instances.

##  Usage

Make sure to include a `mirror-config.yaml` file in the directory where this program is executed, with the following structure:

```yaml
registry_url: "<registry_url>/<project-name>"
```

Then, the rest is easy:

```text
Usage: fata-morgana [-u|--url BASE_URL] (-i|--image IMAGE) [-t|--tag TAG]
  Mirror IMAGE[:TAG] from BASE_URL to a pre-defined registry

Available options:
  -u,--url BASE_URL        Base URL for getting the image. Leave it blank to use default.
  -i,--image IMAGE         Image name.
  -t,--tag TAG             Tag. You can leave this blank.
  -h,--help                Show this help text
```

Obviously the `-i|--image` option is required.
