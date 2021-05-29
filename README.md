#  Fata Morgana

A little toy project to address some FDP chores. This pulls image from some container registry and pushes it to our most recent (cloud) Harbor instance.

##  Usage

Make sure to include a `harbor.yaml` file in the directory where this program is executed, with the following structure:

```yaml
harbor_url: "<harbor_url>/<project-name>"
```

Then, the rest is easy:

```bash
Usage: fata-morgana [-u|--url BASE_URL] (-i|--image IMAGE) [-t|--tag TAG]
  Mirror IMAGE[:TAG] from BASE_URL to a pre-defined registry

Available options:
  -u,--url BASE_URL        Base URL for getting the image. Leave it blank to use default.
  -i,--image IMAGE         Image name.
  -t,--tag TAG             Tag. You can leave this blank.
  -h,--help                Show this help text
```

Obviously the `-i|--image` option is required.
