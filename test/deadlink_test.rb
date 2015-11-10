require 'test_helper'
require 'fakefs/safe'

class DeadlinkTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Deadlink::VERSION
  end

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

  def test_current_argment
    FakeFS.activate!

    FileUtils.mkdir_p 'git_repo/.git'
    FileUtils.mkdir_p 'git_repo/files'

    file_path = File.join('git_repo', 'mdfile.md')
    File.open(file_path, 'a') { |f| f.puts "[dummy](dummy)" }

    file_path = File.join('git_repo/files', 'mdfile.md')
    File.open(file_path, 'a') { |f| f.puts "[dummy](dummy)" }
    
    FileUtils.cd 'git_repo/files'
    scanner = Deadlink::Scanner.new(nil)

    files = scanner.md_files
    assert_equal 2, files.count

    FakeFS.deactivate!
  end

end
