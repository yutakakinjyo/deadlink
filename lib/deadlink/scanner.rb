module Deadlink
  class Scanner
    def initialize(target_path)
      if target_path.nil?
        @repo_root = repo_root(".")
        @target_path = @repo_root
      else
        @target_path = target_path
        @repo_root = repo_root(@target_path)
      end
    end

    def valid?
      unless FileTest.exist?(@target_path)
        puts @target_path + ": No such file or directory"
        return false
      end
      return true
    end

    def md_files
      files = []
      if File.directory?(@target_path)
        Dir.glob(File.join(@target_path, '/**/*.{md,markdown}')) do |file_path|
          files.push(MdFile.new(file_path))
        end
      else
        files = []
        files.push(MdFile.new(@target_path))
      end
      files
    end

    def paths(files)
      paths = []
      files.each do |file|
        paths.concat(scan_paths(file.path))
      end
      Paths.new(paths)
    end

    private

    def scan_paths(file_path)
      paths = []
      File.open(file_path) do |f|
        f.each_with_index do |line, index|
          line.scan /\[[^\]]*\]\(([^)]+)\)/ do |link|
            paths.push Path.new(f.path, link[0], index + 1, @repo_root)
          end
        end
      end
      paths
    end


    def repo_root(target_path)
      dir = target_path
      until dir.empty? do
        return dir if git_repo?(dir)
        dir = prev_dir(dir)
      end
      dir
    end

    def git_repo?(dir)
      Dir.exist?(File.join(dir, ".git"))
    end

    def prev_dir(dir)
      return "" if dir == "/"
      File.expand_path("../", dir)
    end

  end
end
