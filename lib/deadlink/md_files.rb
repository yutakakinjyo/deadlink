require 'forwardable'

module Deadlink
  class MdFiles

    include Enumerable
    extend Forwardable
    def_delegators :@files,:[],:empty?, :each

    def initialize(files)
      @files = files
    end
    
    def header_include?(path, anchor)
      file = find_by(path)
      return file.headers.include?(anchor) unless file.nil?
      false
    end
    
    private

    def find_by(path)
      @files.each { |file| return file if File.expand_path(file.path, File.dirname(file.path)) == File.expand_path(path, File.dirname(path)) }
      nil
    end
    
  end
end
