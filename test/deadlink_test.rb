require 'test_helper'
require 'fakefs/safe'

class DeadlinkTest < Minitest::Test

  def setup
    FakeFS.activate!
  end

  def teardown
    FakeFS::FileSystem.clear
    FakeFS.deactivate!
  end
  
  def test_that_it_has_a_version_number
    refute_nil ::Deadlink::VERSION
  end

  def test_current_argment

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
  end

  def test_non_option

    FileUtils.mkdir_p 'git_repo/.git'
    file_path = File.join('git_repo', 'mdfile.md')
    File.open(file_path, 'a') { |f| f.puts "[dummy](dummy)" }
    FileUtils.cd 'git_repo'
    
    assert_output("dummy in mdfile.md line: 1\n")  { Deadlink.scan()  }
  end

  def test_p_option

    FileUtils.mkdir_p 'git_repo/.git'
    file_path = File.join('git_repo', 'mdfile.md')
    File.open(file_path, 'a') { |f| f.puts "[dummy](dummy)" }
    FileUtils.cd 'git_repo'

    target_dir = nil
    opts = {'p' => true}
    scanner = Deadlink::Scanner.new(target_dir)
    files = scanner.md_files
    paths = scanner.paths(files)

    assert_output("+1 mdfile.md\n")  {  paths.print_deadlinks(opts)  }

  end


end
