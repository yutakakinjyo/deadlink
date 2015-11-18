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

    FakeFS::FileSystem.clear
    FakeFS.deactivate!
  end

  def test_non_option
    assert_output("dummy in mdfile.md line: 1\n")  { 

      FakeFS.activate!

      FileUtils.mkdir_p 'git_repo/.git'
      file_path = File.join('git_repo', 'mdfile.md')
      File.open(file_path, 'a') { |f| f.puts "[dummy](dummy)" }
      FileUtils.cd 'git_repo'

      Deadlink.scan() 

      FakeFS::FileSystem.clear
      FakeFS.deactivate!
    }
  end

  def test_p_option
    assert_output("+1 mdfile.md\n")  { 

      FakeFS.activate!

      FileUtils.mkdir_p 'git_repo/.git'
      file_path = File.join('git_repo', 'mdfile.md')
      File.open(file_path, 'a') { |f| f.puts "[dummy](dummy)" }
      FileUtils.cd 'git_repo'

      target_dir = nil
      opts = {'p' => true}
      scanner = Deadlink::Scanner.new(target_dir)
      files = scanner.md_files
      paths = scanner.paths(files)
      paths.print_deadlinks(opts)

      FakeFS::FileSystem.clear
      FakeFS.deactivate!
    }
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


end
