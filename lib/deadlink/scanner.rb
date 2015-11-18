module Deadlink
  class Scanner
    def initialize(target_dir)
      if target_dir.nil?
        @repo_root = repo_root(".")
        @target_dir = @repo_root
      else
        @target_dir = target_dir
        @repo_root = repo_root(@target_dir)
      end
    end

    def valid?
      unless FileTest.exist?(@target_dir)
        puts @target_dir + ": No such file or directory"
        return false
      end
      return true
    end

    def md_files
      if File.directory?(@target_dir)
        Dir.glob(File.join(@target_dir, '/**/*.{md,markdown}'))
      else
        files = []
        files.push(@target_dir)
      end
    end

    def paths(files)
      paths = []
      files.each do |file|
        File.open(file) do |f|
          f.each_with_index do |line, index|
            line.scan /\[[^\]]*\]\(([^)]+)\)/ do |link|
              paths.push Path.new(f.path, link[0], index + 1, @repo_root)
            end
          end
        end
      end
      Paths.new(paths)
    end

    private

    def repo_root(target_dir)
      dir = target_dir
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
