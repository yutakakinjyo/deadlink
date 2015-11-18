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

    begin
      scanner = Scanner.new(target_dir)
      files = scanner.md_files
      paths = scanner.paths(files)
      paths.print_deadlinks(opts)
    rescue => e
      e.message
    end
  end
end
