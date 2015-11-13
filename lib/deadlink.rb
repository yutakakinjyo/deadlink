require "deadlink/version"
require 'deadlink/scanner'
require 'deadlink/path'
require 'deadlink/paths'
require 'deadlink/decorator'

module Deadlink
  def self.scan(target_dir)
    scanner = Scanner.new(target_dir)
    files = scanner.md_files
    paths = scanner.paths(files)
    paths.print_deadlinks
  end
end
