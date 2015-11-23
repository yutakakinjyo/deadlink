require "deadlink/version"
require 'deadlink/scanner'
require 'deadlink/md_file'
require 'deadlink/path'
require 'deadlink/paths'
require 'deadlink/decorator'
require 'deadlink/md_files.rb'


require 'optparse'

module Deadlink
  def self.scan()

    opts = ARGV.getopts('','p')
    target_path = ARGV[0]

    scanner = Scanner.new(target_path)

    unless scanner.valid?
      exit 1
    end

    files = scanner.md_files

    if files.empty?
      exit 0
    end

    paths = scanner.paths(files)
    paths.print_deadlinks(opts)
  end
end
