require 'test_helper'
require 'fakefs/safe'

class PathsTest < Minitest::Test

  def setup
    FakeFS.activate!
  end

  def teardown
    FakeFS::FileSystem.clear
    FakeFS.deactivate!
  end

  def test_anchor_find
    FileUtils.mkdir_p 'git_repo/.git'
    FileUtils.touch('git_repo/file1.md')
    FileUtils.touch('git_repo/file2.md')

    File.open('git_repo/file1.md', 'a') { |f| f.puts "[dummy](file2.md#header)" }
    File.open('git_repo/file2.md', 'a') { |f| f.puts "# header" }

    scanner = Deadlink::Scanner.new('git_repo')
    files = scanner.md_files
    paths = scanner.paths(files)
    refute paths.deadlink_include?    
  end

  def test_anchor_not_find
    FileUtils.mkdir_p 'git_repo/.git'
    FileUtils.touch('git_repo/file1.md')
    FileUtils.touch('git_repo/file2.md')

    File.open('git_repo/file1.md', 'a') { |f| f.puts "[dummy](file2.md#nothing_header)" }
    File.open('git_repo/file2.md', 'a') { |f| f.puts "# header" }

    scanner = Deadlink::Scanner.new('git_repo')
    files = scanner.md_files
    paths = scanner.paths(files)
    assert paths.deadlink_include?
    
  end
  
end
