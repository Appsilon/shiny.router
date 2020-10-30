# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/).

## [Unreleased]
### Added
### Changed
### Fixed
### Removed

## [0.2.0]

### Added

- js bindings for `shinyrouter` and companion `css` code

- `get_query_param` function

- new documentation

- vignette with tutorial

### Changed

- the way of calling router and ui, now this is one object with fields: server and ui

- parameters go after hash now

### Fixed

- route_link() keeps root url but lose path

- double loading when using browser back button

- stopped rerendering whole page

### Removed

- `router_ui()` function

- old `router` object (eg. replaced by a new `router` list)

## [0.1.0] - 2016-12-05
### Added
- Basic path routing mechanism
- Documentation

[Unreleased]: https://github.com/Appsilon/shiny.router/compare/0.1.0...HEAD
[0.1.0]: https://github.com/Appsilon/shiny.router/compare/12b021ae1eb9cbadbd4fde3d1ea54a2fd35e3098...0.1.0
