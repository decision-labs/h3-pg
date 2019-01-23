# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Changed
- Renamed `h3_basecells` to `h3_get_res_0_indexes`.
- Renamed all functions with double `h3_h3_` prefix to use single `h3_` prefix.

## [0.4.0] - 2019-01-12
### Added
- Added h3_line (binding for h3Line)
### Fixed
- Fixed h3_h3_to_children_slow

## [0.3.2] - 2019-01-08
### Fixed
- Fixed B-Tree operators, now indexing works.

## [0.3.1] - 2018-12-17
### Changed
- Added flag `extend` such that polygons returned by `h3_h3_to_geo_boundary` are not wrapped at 180th meridian.

## 0.3.0 - 2018-12-11
### Added
- First public release.

[0.4.0]: https://github.com/bytesandbrains/h3-pg/compare/v0.3.2...v0.4.0
[0.3.2]: https://github.com/bytesandbrains/h3-pg/compare/v0.3.1...v0.3.2
[0.3.1]: https://github.com/bytesandbrains/h3-pg/compare/v0.3.0...v0.3.1