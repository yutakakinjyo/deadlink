require 'test_helper'
require 'fakefs/safe'

class MdFileTest < Minitest::Test
  
  def setup
    FakeFS.activate!
    FileUtils.mkdir_p 'git_repo/.git'
    FileUtils.cd 'git_repo'
  end

  def teardown
    FakeFS::FileSystem.clear
    FakeFS.deactivate!
  end
  
  def test_get_single_sharp_headers

    File.open('mdfils.md', 'a') do |f|
      f.puts "# header1"
    end
    
    scanner = Deadlink::Scanner.new(nil)
    files = scanner.md_files
    headers = files[0].headers

    assert_equal 1, headers.count
    assert_equal "header1", headers[0]

  end

  def test_get_two_sharp_headers

    File.open('mdfils.md', 'a') do |f|
      f.puts "## header1"
    end

    scanner = Deadlink::Scanner.new(nil)
    files = scanner.md_files

    headers = files[0].headers

    assert_equal 1, headers.count
    assert_equal "header1", headers[0]

  end

  def test_bad_synntax_sharp_headers

    File.open('mdfils.md', 'a') do |f|
      f.puts "#header1"
    end
    
    scanner = Deadlink::Scanner.new(nil)
    files = scanner.md_files
    headers = files[0].headers

    assert_equal 0, headers.count

  end

  def test_two_sentence_sharp_headers

    File.open('mdfils.md', 'a') do |f|
      f.puts "# header1"
      f.puts "## header2"
    end
    
    scanner = Deadlink::Scanner.new(nil)
    files = scanner.md_files
    headers = files[0].headers

    assert_equal 2, headers.count
    assert_equal "header1", headers[0]
    assert_equal "header2", headers[1]

  end

  def test_many_sharp_headers

    File.open('mdfils.md', 'a') do |f|
      f.puts "####### header1"
    end
    
    scanner = Deadlink::Scanner.new(nil)
    files = scanner.md_files
    headers = files[0].headers
    assert_equal 0, headers.count

  end
  
  def test_get_nothing_sharp_headers

    File.open('mdfils.md', 'a') do |f|
      f.puts "[dummy](mdfile.md#header1)"
    end
    
    scanner = Deadlink::Scanner.new(nil)
    files = scanner.md_files
    headers = files[0].headers
    assert_equal 0, headers.count

  end

  def test_two_file_sharp_headers
    File.open('mdfils.md', 'a') do |f|
      f.puts "# file1 header"
    end

    File.open("mdifle2.md", 'a') do |f|
      f.puts "# file2 header1"
      f.puts "# file2 header2"
    end
    
    scanner = Deadlink::Scanner.new(nil)
    files = scanner.md_files
    assert_equal 1, files[0].headers.count
    assert_equal 2, files[1].headers.count
  end

  def test_one_sentence_links
    File.open('mdfils.md', 'a') do |f|
      f.puts "# [dummy](link1) [dummy](link2)"
    end

    scanner = Deadlink::Scanner.new(nil)
    files = scanner.md_files
    assert_equal 1, files[0].headers.count
    assert_equal 2, files[0].link_paths.count

  end

  def test_under_header
    File.open('file1.md', 'a') do |f|
      f.puts "[dummy](file1.md#header)"
      f.puts "header"
      f.puts "----"
    end

    scanner = Deadlink::Scanner.new(nil)
    files = scanner.md_files
    paths = scanner.paths(files)
    assert_equal 0, paths.deadlinks.count
  end

  def test_under_two_header
    File.open('file1.md', 'a') do |f|
      f.puts "[dummy](file1.md#header)"
      f.puts "header"
      f.puts "----"
      f.puts "----"
    end

    scanner = Deadlink::Scanner.new(nil)
    files = scanner.md_files
    paths = scanner.paths(files)
    assert_equal 0, paths.deadlinks.count
  end

  def test_under_header_next_line
    File.open('file1.md', 'a') do |f|
      f.puts "[dummy](file1.md#header)"
      f.puts "header"
      f.puts ""
      f.puts "----"
    end

    scanner = Deadlink::Scanner.new(nil)
    files = scanner.md_files
    paths = scanner.paths(files)
    assert_equal 1, paths.deadlinks.count
  end

  def test_mix_plus_under_header
    File.open('file1.md', 'a') do |f|
      f.puts "[dummy](file1.md#header)"
      f.puts "header"
      f.puts ""
      f.puts "----+"
    end

    scanner = Deadlink::Scanner.new(nil)
    files = scanner.md_files
    paths = scanner.paths(files)
    assert_equal 1, paths.deadlinks.count
  end

  def test_mix_equal_under_header
    File.open('file1.md', 'a') do |f|
      f.puts "[dummy](file1.md#header)"
      f.puts "header"
      f.puts ""
      f.puts "----="
    end

    scanner = Deadlink::Scanner.new(nil)
    files = scanner.md_files
    paths = scanner.paths(files)
    assert_equal 1, paths.deadlinks.count
  end


  def test_under_equal_header
    File.open('file1.md', 'a') do |f|
      f.puts "[dummy](file1.md#header)"
      f.puts "header"
      f.puts "===="
    end

    scanner = Deadlink::Scanner.new(nil)
    files = scanner.md_files
    paths = scanner.paths(files)
    assert_equal 0, paths.deadlinks.count
  end

  def test_under_eq
    File.open('file1.md', 'a') do |f|
      f.puts "[dummy](#header)"
      f.puts "header"
      f.puts "===="
    end

    scanner = Deadlink::Scanner.new(nil)
    files = scanner.md_files
    paths = scanner.paths(files)
    assert_equal 0, paths.deadlinks.count
  end

  def test_under_header_anchor_only

    File.open('file1.md', 'a') do |f|
      f.puts "[dummy](#header)"
      f.puts "header"
      f.puts ""
      f.puts "----"
    end

    scanner = Deadlink::Scanner.new(nil)
    files = scanner.md_files
    paths = scanner.paths(files)
    assert_equal 0, paths.deadlinks.count
  end


  
end
