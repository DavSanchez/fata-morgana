# Revision history for fata-morgana

## 0.3.0.0 -- 2021-05-30

* Refactored project structure.
* Protected against:
  * Empty image names (program errors and quits.)
  * Trailing slashes in image and tag names (stripped.)
* Implementing unit tests.

### TODO

Handle URLs better (protect against empty values where illegal, etc.)

## 0.2.0.1 -- 2021-05-29

* Refactored the way to call external `docker` commands.

## 0.2.0.0 -- 2021-05-29

* Renamed needed filename from `harbor-yaml` to `mirror-config.yaml`, and also modified its required field structure.

## 0.1.0.0 -- 2021-05-29

* First version. Released on an unsuspecting world.
