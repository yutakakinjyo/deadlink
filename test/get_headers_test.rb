require 'test_helper'
require 'fakefs/safe'

class DeadlinkTest < Minitest::Test

  def test_get_single_atx_headers

    FakeFS.activate!

    FileUtils.mkdir_p 'git_repo/.git'
    file_path = File.join('git_repo', 'mdfile.md')

    File.open(file_path, 'a') do |f|
      f.puts "[dummy](mdfile.md#header1)"
      f.puts "# header1"
    end
    
    FileUtils.cd 'git_repo'

    scanner = Deadlink::Scanner.new(nil)
    files = scanner.md_files
    headers = scanner.headers(files[0])

    assert_equal 1, headers.count

    FakeFS::FileSystem.clear
    FakeFS.deactivate!
    
  end

  def test_get_two_atx_headers

    FakeFS.activate!

    FileUtils.mkdir_p 'git_repo/.git'
    file_path = File.join('git_repo', 'mdfile.md')

    File.open(file_path, 'a') do |f|
      f.puts "[dummy](mdfile.md#header1)"
      f.puts "## header1"
    end
    
    FileUtils.cd 'git_repo'

    scanner = Deadlink::Scanner.new(nil)
    files = scanner.md_files
    headers = scanner.headers(files[0])

    assert_equal 1, headers.count

    FakeFS::FileSystem.clear
    FakeFS.deactivate!
    
  end

  def test_bad__synntax_atx_headers

    FakeFS.activate!

    FileUtils.mkdir_p 'git_repo/.git'
    file_path = File.join('git_repo', 'mdfile.md')

    File.open(file_path, 'a') do |f|
      f.puts "[dummy](mdfile.md#header1)"
      f.puts "#header1"
    end
    
    FileUtils.cd 'git_repo'

    scanner = Deadlink::Scanner.new(nil)
    files = scanner.md_files
    headers = scanner.headers(files[0])

    assert_equal 0, headers.count

    FakeFS::FileSystem.clear
    FakeFS.deactivate!
    
  end

  def test_many_atx_headers

    FakeFS.activate!

    FileUtils.mkdir_p 'git_repo/.git'
    file_path = File.join('git_repo', 'mdfile.md')

    File.open(file_path, 'a') do |f|
      f.puts "[dummy](mdfile.md#header1)"
      f.puts "######## header1"
    end
    
    FileUtils.cd 'git_repo'

    scanner = Deadlink::Scanner.new(nil)
    files = scanner.md_files
    headers = scanner.headers(files[0])

    assert_equal 0, headers.count

    FakeFS::FileSystem.clear
    FakeFS.deactivate!
    
  end
  
  def test_get_nothing_atx_headers

    FakeFS.activate!

    FileUtils.mkdir_p 'git_repo/.git'
    file_path = File.join('git_repo', 'mdfile.md')

    File.open(file_path, 'a') do |f|
      f.puts "[dummy](mdfile.md#header1)"
    end
    
    FileUtils.cd 'git_repo'

    scanner = Deadlink::Scanner.new(nil)
    files = scanner.md_files
    headers = scanner.headers(files[0])
    assert_equal 0, headers.count

    FakeFS::FileSystem.clear
    FakeFS.deactivate!
    
  end
  
end
