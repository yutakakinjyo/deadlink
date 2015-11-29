# coding: utf-8
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
      f.puts "[dummy](#header-three)"
      f.puts "[dummy](#header-four)"
      f.puts "[dummy](#header-five-six)"
      f.puts "# HeaderOne"
      f.puts "# Header Two"
      f.puts "# Header Three  "
      f.puts "# Header  Four"
      f.puts "# Header  Five   Six  "
    end

    scanner = Deadlink::Scanner.new('git_repo')
    files = scanner.md_files
    paths = scanner.paths(files)
    assert_equal 0, paths.deadlinks.count
  end

  def test_image_link

    File.open('git_repo/image.png', 'a')
    File.open('git_repo/file1.md', 'a') do |f|
      f.puts "![dummy](image.png)"
    end
    
    scanner = Deadlink::Scanner.new('git_repo')
    files = scanner.md_files
    paths = scanner.paths(files)
    assert_equal 0, paths.deadlinks.count
  end

  def test_image_query_link

    File.open('git_repo/image.png', 'a')
    File.open('git_repo/file1.md', 'a') do |f|
      f.puts "![dummy](image.png?raw=true)"
    end
    
    scanner = Deadlink::Scanner.new('git_repo')
    files = scanner.md_files
    paths = scanner.paths(files)
    assert_equal 0, paths.deadlinks.count
  end

  def test_tail_whitespace_link

    FileUtils.touch('git_repo/file2.md')
    File.open('git_repo/file1.md', 'a') do |f|
      f.puts "[dummy](file2.md )"
    end
    
    scanner = Deadlink::Scanner.new('git_repo')
    files = scanner.md_files
    paths = scanner.paths(files)
    assert_equal 0, paths.deadlinks.count
  end
  
end
