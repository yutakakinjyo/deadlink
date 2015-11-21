require 'test_helper'
require 'fakefs/safe'

class ScannerTest < Minitest::Test

  def setup
    FakeFS.activate!
  end

  def teardown
    FakeFS::FileSystem.clear
    FakeFS.deactivate!
  end

  def test_get_md_files

    FileUtils.mkdir_p 'git_repo/.git'
    FileUtils.mkdir_p 'git_repo/dir1/'
    FileUtils.mkdir_p 'git_repo/dir2/'
    FileUtils.touch('git_repo/file1.md')
    FileUtils.touch('git_repo/dir1/file2.md')
    FileUtils.touch('git_repo/dir2/file3.md')

    sccaner = Deadlink::Scanner.new('git_repo')
    files = sccaner.md_files
    assert_equal 3, files.count
  end

  def test_markdown_extension

    FileUtils.mkdir_p 'git_repo/.git'

    file_path = File.join('git_repo', 'mdfile.markdown')
    File.open(file_path, 'a') { |f| f.puts "[dummy](dummy)" }
    
    scanner = Deadlink::Scanner.new('git_repo')

    files = scanner.md_files
    assert_equal 1, files.count
  end

  def test_specify_a_file

    FileUtils.mkdir_p 'git_repo/.git'
    file_path = File.join('git_repo', 'mdfile.md')
    File.open(file_path, 'a') { |f| f.puts "[dummy](dummy)" }
    FileUtils.cd 'git_repo'

    target = 'mdfile.md'
    scanner = Deadlink::Scanner.new(target)
    files = scanner.md_files

    assert_equal 1, files.count
  end

  def test_invalid_file_path

    target = './nothing_dif'

    assert_output ( "./nothing_dif: No such file or directory\n" ) {
      scanner = Deadlink::Scanner.new(target)
      refute scanner.valid?
    }
    
  end
  
end
