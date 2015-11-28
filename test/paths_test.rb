require 'test_helper'
require 'fakefs/safe'

class PathsTest < Minitest::Test

  def setup
    FakeFS.activate!
    FileUtils.mkdir_p 'git_repo/.git'
  end

  def teardown
    FakeFS::FileSystem.clear
    FakeFS.deactivate!
  end

  def test_anchor_find
    File.open('git_repo/file1.md', 'a') { |f| f.puts "[dummy](file2.md#header)" }
    File.open('git_repo/file2.md', 'a') { |f| f.puts "# header" }

    scanner = Deadlink::Scanner.new('git_repo')
    files = scanner.md_files
    paths = scanner.paths(files)
    refute paths.deadlink_include?    
  end

  def test_anchor_not_found_any_file
    File.open('git_repo/file1.md', 'a') { |f| f.puts "[dummy](file2.md#nothing_header)" }
    File.open('git_repo/file2.md', 'a') { |f| f.puts "# header" }

    scanner = Deadlink::Scanner.new('git_repo')
    files = scanner.md_files
    paths = scanner.paths(files)
    assert paths.deadlink_include?
  end

  def test_anchor_not_found
    File.open('git_repo/file1.md', 'a') { |f| f.puts "[dummy](file2.md#header)" }
    File.open('git_repo/file2.md', 'a') { |f| f.puts "nothing header" }
    File.open('git_repo/file3.md', 'a') { |f| f.puts "# header" }

    scanner = Deadlink::Scanner.new('git_repo')
    files = scanner.md_files
    paths = scanner.paths(files)
    assert paths.deadlink_include?
  end

  def test_anchor_only

    File.open('git_repo/file1.md', 'a') do |f|
      f.puts "[dummy](#header)"
      f.puts "# header"
    end

    scanner = Deadlink::Scanner.new('git_repo')
    files = scanner.md_files
    paths = scanner.paths(files)
    refute paths.deadlink_include?
  end

  def test_anchor_only

    File.open('git_repo/file1.md', 'a') do |f|
      f.puts "[dummy](#header)"
      f.puts "# header"
    end

    scanner = Deadlink::Scanner.new('git_repo')
    files = scanner.md_files
    paths = scanner.paths(files)
    refute paths.deadlink_include?
  end

  def test_two_anchor_only

    File.open('git_repo/file1.md', 'a') do |f|
      f.puts "[dummy](#header1)"
      f.puts "[dummy](#header2)"
      f.puts "# header1"
      f.puts "# header2"
    end

    scanner = Deadlink::Scanner.new('git_repo')
    files = scanner.md_files
    paths = scanner.paths(files)
    refute paths.deadlink_include?
  end

  def test_normalize_anchor

    File.open('git_repo/file1.md', 'a') do |f|
      f.puts "[dummy](#headerone)"
      f.puts "[dummy](#header-two)"
      f.puts "# HeaderOne"
      f.puts "# Header Two"
    end

    scanner = Deadlink::Scanner.new('git_repo')
    files = scanner.md_files
    paths = scanner.paths(files)
    assert_equal 0, paths.deadlinks.count
    refute paths.deadlink_include?

  end
  
end
