# v0.1.4 2016-01-27

### Added

* Support for hash-names in `Check` and `Result` which can properly resolve input
  from nested results (solnic)

[Compare v0.1.3...v0.1.4](https://github.com/dryrb/dry-logic/compare/v0.1.3...v0.1.4)

# v0.1.3 2016-01-27

### Added

* Support for resolving input from `Rule::Result` (solnic)

### Changed

* `Check` and `Result` carry original input(s) (solnic)

[Compare v0.1.2...v0.1.3](https://github.com/dryrb/dry-logic/compare/v0.1.2...v0.1.3)

# v0.1.2 2016-01-19

### Fixed

* `xor` returns wrapped results when used against another result-rule (solnic)

[Compare v0.1.1...v0.1.2](https://github.com/dryrb/dry-logic/compare/v0.1.1...v0.1.2)

# v0.1.1 2016-01-18

### Added

* `Rule::Attr` which can be applied to a data object with attr readers (SunnyMagadan)
* `Rule::Result` which can be applied to a result object (solnic)
* `true?` and `false?` predicates (solnic)

[Compare v0.1.0...v0.1.1](https://github.com/dryrb/dry-logic/compare/v0.1.0...v0.1.1)

# v0.1.0 2016-01-11

Code extracted from dry-validation 0.4.1
