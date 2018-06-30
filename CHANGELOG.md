# master
##### Enhancements
- added `-reduce` method on NSArray and NSSet

##### Bug Fixes

- NSMutableArray -keepIf was mutating the collection while iterating
- !!BREAKING `-map` on NSArray now puts NSNulls if the block returns nil
- !!BREAKING `-map` on NSSet doesn't blow up if the block returns nil.


# 1.1.1

##### Bug Fixes

- Array range accesors with backwards range (e.g. array[@"0..-2"])

# 1.1.0

##### Enhancements

- `until` keyword, and improved `unless` (it allows you to pass args) |
  [C0deH4cker #61](https://github.com/supermarin/ObjectiveSugar/pull/61)
- Force the library to load under ARC |
  [mickeyreiss #62](https://github.com/supermarin/ObjectiveSugar/pull/62)

# 1.0.0

* The library is stable, warning-less and production-ready

* Thanks everybody for contributing and all the great PRs.
  Since the library is stable enough and we almost never had to fix things,
  it's time to release 1.0.

* Documentation could be better, and we encourage you to write some.
  Thanks [@orta](https://github.com/orta) for initiating that.

