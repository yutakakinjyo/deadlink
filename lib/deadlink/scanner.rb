module Deadlink
  class Scanner
    def initialize(target_dir)
      @target_dir = target_dir
    end

    def md_files
      Dir.glob(@target_dir + '/**/*.md')
    end

    def paths(files)
      paths = []
      files.each do |file|
        File.open(file) do |f|
          f.each_with_index do |line, index|
            line.scan /\[[^\]]*\]\(([^)]+)\)/ do |link|
              paths.push Path.new(f.path, link[0], index + 1)
            end
          end
        end
      end
      Paths.new(paths)
    end
  end
end
