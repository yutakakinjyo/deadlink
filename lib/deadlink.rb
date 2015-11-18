require "deadlink/version"
require 'deadlink/scanner'
require 'deadlink/path'
require 'deadlink/paths'
require 'deadlink/decorator'
require 'optparse'

module Deadlink
  def self.scan()

    opts = ARGV.getopts('','p')
    target_dir = ARGV[0]

    scanner = Scanner.new(target_dir)

    unless scanner.valid?
      exit 1
    end

    files = scanner.md_files
    paths = scanner.paths(files)
    paths.print_deadlinks(opts)
  end
end
