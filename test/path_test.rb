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

  def test_check_exist
     files = @scanner.md_files
     paths = @scanner.paths(files)
     assert paths.deadlink_include?
  end

  def test_noting_anchor
    FakeFS.activate!

    FileUtils.mkdir_p 'git_repo/.git'
    file_path = File.join('git_repo', 'mdfile.md')

    File.open(file_path, 'a') do |f|
      f.puts "[dummy](mdfile.md#nothing_title)"
    end
    
    FileUtils.cd 'git_repo'

    scanner = Deadlink::Scanner.new(nil)
    files = scanner.md_files
    paths = scanner.paths(files)

    assert_equal 1, paths.deadlinks.count

    FakeFS::FileSystem.clear
    FakeFS.deactivate!
  end

  
end
