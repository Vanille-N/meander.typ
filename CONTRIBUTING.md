# Guide to contributing

The [README](README.md) is aimed at users of the package,
this is aimed at developpers, including myself for future reference
and anyone interested in contributing code or ideas.

## Dependencies

Having the following installed is necessary or helpful while developing Meander:
- Typst (duh!),
- [just][just] to run some commands,
- [tytanic][tytanic] for testing,
- [scrybe][scrybe] to validate files before publishing.
- the commands [rsync][rsync] and [git][git] for synchronization during updates,

## Project organization

Folders:
- `autocontour/` is an auxiliary tool for computing contour files.
  See the dedicated [README](autocontour/README.md).
- `demo/` is a presentation that I gave at the dedicated spotlight
  during the 2025 Typst Community Call.
- `docs/` holds the documentation.
- `release/` is created when publishing a new version.
- `src/` contains the entire source code.
- `tests/` contains unit tests for Meander.
- `examples/` is outdated.
  The contents have been moved to `tests/examples/` and the folder
  will be deleted eventually.
- `gallery/` is outdated.
  The contents have been moved to `tests/gallery/` and the folder
  will be deleted eventually.

Files:
- `justfile` contains shortcuts to some commands useful during development.
- `typst.toml` and `README.md` contain the required metadata and documentation
  for package publication.
- `CHANGELOG.md`, `CONTRIBUTING.md`, `LICENSE`, `ROADMAP.md` contain the standard
  list of past changes, contributing guidelines, MIT licensing restrictions, future
  planned changes respectively.

Hidden:
- `.packages` is a reference to my local copy of [typst/packages][typst_packages],
- `.version` contains the latest version number to be accessed for validation by Scrybe.

### Testing Framework

Meander uses [tytanic][tytanic] as a test runner,
invoked via
```sh
# Run all
$ tt run

# Update all
$ tt update

# Run only core tests for quick checking
$ tt run -e 'r:core'
```

The test directory is `tests/`, and it includes the suites:
- `core` for basic features
- `advanced` for more complex layouts
- `issues` to track regressions to fixed or ongoing [GitHub issues][this_repo_issues]
- `examples` for applications featured e.g. on [the Typst Forum Showcase][forum_showcase]
- `gallery` for layouts featured on the [README](README.md)
- `figs` for examples that are used in the [documentation](docs/docs.pdf)

### Documentation

Run
```sh
$ just doc
```
to watch and compile changes to the documentation in `docs/docs.pdf`.
The source code is in `docs/docs.typ`.
The manual uses [mantys][mantys] as a template.

(Almost) all code snippets used in the documentation are tested for regressions,
and are thus stored and built in `tests/figs/`.
The functions `show-code` and `show-page` allow extracting code from source files
and displaying the images from the tests.
This enables faster building of the documentation and guarantees the absence of
regressions, but does come at the cost of a slight overhead when creating new
examples or tweaking existing ones, as it requires a `tt update figs/_` each time.

### Release process

Broadly, before a new release, the following should be executed:
```sh
# Bump the version number
just bump x.x.x

# Check that the repo is self-consistent
just scrybe
# (fix all issues that arise)

# Copy over the necessary files
just publish

# Update some release-specific data
just scrybe-publish
# (fix all issues that arise)

# Send to typst/packages
# (make sure that .packages points to the correct local fork of typst/packages)
just upstream
```

In more detail, `just bump x.x.x` will update the version number stored in `.version`,
then `just scrybe` invokes a personal tool, [scrybe][scrybe], that is a readonly
evaluator for inline commands to check that a document is self-consistent.
Among the things that scrybe is capable of checking, are:
- whether relative links have been updated to absolute `https://` paths,
- if examples in the README are up to date,
- if the documentation has been updated with correct version numbers.

`just publish` runs a convoluted `rsync` command to copy the necessary
files to the folder `release/`. Some adjustments are then necessary:
- `@local/meander:x.x.x` imports need to be updated to `@preview/meander:x.x.x`,
- local links in the [README](README.md) need to be updated to absolute `https://`
  paths, specifically for the documentation for example,
If you forget one of these, it will be caught by `just scrybe-publish`,
after which `just upstream` will do the rest of the job and a PR can be opened right away.


[this_repo_issues]: https://github.com/Vanille-N/meander.typ/issues
[forum_showcase]: https://forum.typst.app/t/meander-0-2-2-wrapping-text-around-images/6096
[tytanic]: https://github.com/typst-community/tytanic
[just]: https://github.com/casey/just
[mantys]: https://typst.app/universe/package/mantys
[scrybe]: https://github.com/Vanille-N/scrybe
[rsync]: https://linux.die.net/man/1/rsync
[git]: https://git-scm.com
[typst_packages]: https://github.com/typst/packages

