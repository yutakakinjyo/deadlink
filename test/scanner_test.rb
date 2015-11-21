require 'test_helper'
require 'fakefs/safe'

class ScannerTest < Minitest::Test

  def setup
    @target_dir = File.expand_path('files', File.dirname(__FILE__))
    @scanner = Deadlink::Scanner.new(@target_dir)
  end

  def test_get_md_files
    files = @scanner.md_files
    assert_equal 11, files.count
  end

  def test_get_nest_md_files
    target_dir = File.expand_path('files/dir1', File.dirname(__FILE__))
    scanner = Deadlink::Scanner.new(target_dir)

    files = scanner.md_files
    assert_equal 2, files.count
  end

  def test_markdown_extension
    FakeFS.activate!

    FileUtils.mkdir_p 'git_repo/.git'

    file_path = File.join('git_repo', 'mdfile.markdown')
    File.open(file_path, 'a') { |f| f.puts "[dummy](dummy)" }
    
    scanner = Deadlink::Scanner.new('git_repo')

    files = scanner.md_files
    assert_equal 1, files.count

    FakeFS::FileSystem.clear
    FakeFS.deactivate!
  end

  def test_specify_a_file
    FakeFS.activate!

    FileUtils.mkdir_p 'git_repo/.git'
    file_path = File.join('git_repo', 'mdfile.md')
    File.open(file_path, 'a') { |f| f.puts "[dummy](dummy)" }
    FileUtils.cd 'git_repo'

    target = 'mdfile.md'
    scanner = Deadlink::Scanner.new(target)
    files = scanner.md_files

    assert_equal 1, files.count

    FakeFS::FileSystem.clear
    FakeFS.deactivate!
  end

  def test_invalid_file_path

    target = './nothing_dif'

    assert_output ( "./nothing_dif: No such file or directory\n" ) {
      scanner = Deadlink::Scanner.new(target)
      refute scanner.valid?
    }
    
  end
  
end
