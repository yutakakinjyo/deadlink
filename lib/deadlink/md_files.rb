require 'forwardable'

module Deadlink
  class MdFiles

    include Enumerable
    extend Forwardable
    def_delegators :@files,:[],:empty?, :each

    def initialize(files)
      @files = files
    end
    
    def find_by(path)
      @files.each { |file| return file if  abs(file.path) == abs(path) }
      nil
    end
    
    private

    def abs(path)
      File.expand_path(path, File.dirname(path))
    end
    
  end
end
