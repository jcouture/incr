<p align="center">
  <a href="https://github.com/jcouture/incr">
    <img src="https://i.imgur.com/cHimJRm.png" alt="incr" />
  </a>
  <br />
  Incr is a tool to help you easily increment the version number of your NPM or Mix packages.
  <br /><br />
  <a href="https://rubygems.org/gems/incr"><img src="http://img.shields.io/gem/v/incr.svg" /></a>
  <a href="https://codeclimate.com/github/jcouture/incr"><img src="http://img.shields.io/codeclimate/github/jcouture/incr.svg" /></a>
  <a href="https://gemnasium.com/jcouture/incr"><img src="http://img.shields.io/gemnasium/jcouture/incr.svg" /></a>
  <a href="https://travis-ci.org/jcouture/incr"><img src="http://img.shields.io/travis/jcouture/incr.svg" /></a>
</p>

## What does `incr` do?

The process is detailed as follow:

*  Find the relevant file(s) (e.g.: `package.json` and `package-lock.json` or `mix.exs`).
* Determine the existing version number.
* Increment the specified segment. If you increment the minor segment, the patch segment is set to 0 and the same goes for the major segment, the minor and patch segments are set to 0.
* Write the newly incremented version number in the relevant file(s).
* Create a new `git commit` with the relevant file with the version number as the default message (e.g.: 0.2.1).
* Create a new `git tag` pointing to the new `git commit` with the version number prefixed by a 'v' as the name (e.g.: v0.2.1).
* 💥

## Installation

### Prerequisites

incr depends on the [Rugged](https://github.com/libgit2/rugged) Ruby bindings for [libgit2](https://libgit2.github.com/). You need to have `CMake` and `pkg-config` installed on your system to be able to build the included version of libgit2.
On mac OS, after installing [Homebrew](https://brew.sh/), you can get `CMake` with:

```shell
~> brew install cmake
```

### incr

```shell
~> gem install incr
```

## Usage
To increment the patch segment of your NPM package version number:
```shell
~> incr npm patch
```

To increment the minor segment of your Mix package version number:
```shell
~> incr mix minor
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jcouture/incr. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

The incr shield logo is based on [this icon](https://thenounproject.com/term/increment/621415/) by [blackspike](https://thenounproject.com/blackspike/), from the Noun Project. Used under a [Creative Commons BY 3.0](http://creativecommons.org/licenses/by/3.0/) license.
