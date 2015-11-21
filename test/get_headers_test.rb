require 'test_helper'
require 'fakefs/safe'

class DeadlinkTest < Minitest::Test

  
  def ready_file
    FileUtils.mkdir_p 'git_repo/.git'
    FileUtils.cd 'git_repo'
    FakeFS.activate!
  end

  def close_file
    FakeFS::FileSystem.clear
    FakeFS.deactivate!
  end
  
  def test_get_single_atx_headers

    ready_file
    
    File.open('mdfils.md', 'a') do |f|
      f.puts "# header1"
    end
    
    scanner = Deadlink::Scanner.new(nil)
    files = scanner.md_files
    headers = scanner.headers(files[0])

    assert_equal 1, headers.count
    assert_equal "header1", headers[0]

    close_file
  end

  def test_get_two_atx_headers

    ready_file
    
    File.open('mdfils.md', 'a') do |f|
      f.puts "## header1"
    end

    scanner = Deadlink::Scanner.new(nil)
    files = scanner.md_files
    headers = scanner.headers(files[0])

    assert_equal 1, headers.count
    assert_equal "header1", headers[0]

    close_file
  end

  def test_bad_synntax_atx_headers

    ready_file
    
    File.open('mdfils.md', 'a') do |f|
      f.puts "#header1"
    end
    
    scanner = Deadlink::Scanner.new(nil)
    files = scanner.md_files
    headers = scanner.headers(files[0])

    assert_equal 0, headers.count

    close_file
  end

  def test_two_sentence_atx_headers

    ready_file

    File.open('mdfils.md', 'a') do |f|
      f.puts "# header1"
      f.puts "## header2"
    end
    
    scanner = Deadlink::Scanner.new(nil)
    files = scanner.md_files
    headers = scanner.headers(files[0])

    assert_equal 2, headers.count
    assert_equal "header1", headers[0]
    assert_equal "header2", headers[1]

    close_file
  end


  def test_many_atx_headers

    ready_file
    
    File.open('mdfils.md', 'a') do |f|
      f.puts "####### header1"
    end
    
    scanner = Deadlink::Scanner.new(nil)
    files = scanner.md_files
    headers = scanner.headers(files[0])

    assert_equal 0, headers.count

    close_file
  end
  
  def test_get_nothing_atx_headers

    ready_file
    
    File.open('mdfils.md', 'a') do |f|
      f.puts "[dummy](mdfile.md#header1)"
    end
    
    scanner = Deadlink::Scanner.new(nil)
    files = scanner.md_files
    headers = scanner.headers(files[0])
    assert_equal 0, headers.count

    close_file
  end

  def test_two_file_atx_headers

    skip();
    
    File.open('mdfils.md', 'a') do |f|
      f.puts "# file1 header"
    end

    File.open("mdifle2.md", 'a') do |f|
      f.puts "# file2 header"
    end
    
    scanner = Deadlink::Scanner.new(nil)
    files = scanner.md_files
    headers = scanner.headers(files[0])
    assert_equal 0, headers.count
  end
  
end
