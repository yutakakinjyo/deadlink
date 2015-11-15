require 'test_helper'
require 'fakefs/safe'

class DeadlinkTest < Minitest::Test

  def setup
    @target_dir = File.expand_path('files', File.dirname(__FILE__))
    @scanner = Deadlink::Scanner.new(@target_dir)
  end

  def test_get_md_files
    files = @scanner.md_files
    assert_equal 11, files.count
    assert files.include?(@target_dir + '/file1.md')
    assert files.include?(@target_dir + '/file2.md')
    assert files.include?(@target_dir + '/top.md')
    assert files.include?(@target_dir + '/dir1/nest_file1.md')
    assert files.include?(@target_dir + '/dir1/nest_file2.md')
    assert files.include?(@target_dir + '/dir2/http.md')
  end

  def test_get_nest_md_files
    target_dir = File.expand_path('files/dir1', File.dirname(__FILE__))
    scanner = Deadlink::Scanner.new(target_dir)

    files = scanner.md_files
    assert_equal 2, files.count
    assert files.include?(target_dir + '/nest_file1.md')
    assert files.include?(target_dir + '/nest_file2.md')
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


end
