require 'test_helper'
require 'fakefs/safe'

class PathTest < Minitest::Test

  def setup
    @target_dir = File.expand_path('files', File.dirname(__FILE__))
    @scanner = Deadlink::Scanner.new(@target_dir)
  end

  def test_get_paths
    files = @scanner.md_files
    paths = @scanner.paths(files)
    assert_equal 15, paths.count
  end

  def test_check_deadlinks
    files = @scanner.md_files
    paths = @scanner.paths(files)
    assert_equal 4, paths.deadlinks.count
  end

  def test_check_exist
    files = @scanner.md_files
    paths = @scanner.paths(files)
    assert paths.deadlink_include?
  end
  
end
