# Deadlink

[![Build Status](https://travis-ci.org/yutakakinjyo/deadlink.svg?branch=master)](https://travis-ci.org/yutakakinjyo/deadlink)
[![Code Climate](https://codeclimate.com/github/yutakakinjyo/deadlink/badges/gpa.svg)](https://codeclimate.com/github/yutakakinjyo/deadlink)

Check **deadlink** of markdown files in your git repository.

**Example**

`$ ls`

`git_repo`

`$ deadlink git_repo`

show deadlink info.

`<deadlink> in <md file path> line: <line number>`

case of this repository

```
$ git clone git@github.com:yutakakinjyo/deadlink.git
$ deadlink deadlink/
```

result is this

```
example.md#title1 in ./README.md line: 43
contributor-covenant.org in ./README.md line: 73
nothing_file3.md in ./test/files/dir1/nest_file1.md line: 2
dir1/nothing_nest_file2.md in ./test/files/top.md line: 3
nothing_dir in ./test/files/top.md line: 5
nothing.txt in ./test/files/top.md line: 8
```

## not check patterns

this gem not check following patterns yet. applying these patterns to gem is future task.

- http(s) link
- anchor link ( only check file path part )
  - e.g. `[anhor link](example.md#title1)` => check example.md 
- multibyte characters
- specify file.

## Installation

`$ gem install deadlink`

## Usage

specify path of directory

```
$ deadlink <dir>
```

if you want to start scanning from current directory, you can specify `.` to `<dir>` path

```
$ deadlink .
```

if you not specify `<dir>` path, deadlink scan top directory of current git repository.

```
$ deadlink
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yutakakinjyo/deadlink. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

