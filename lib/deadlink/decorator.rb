module Deadlink
  class Decorator
    def self.print_info(path,opts)
      if opts['p']
        for_editor(path)
      else
        default(path)
      end
    end

    private
    
    def self.for_editor(path)
      puts '+' + path.index.to_s + " " + path.cur_file_path
    end

    def self.default(path)
      puts path.link + ' in ' + path.cur_file_path + ' line: ' + path.index.to_s
    end
    
  end
end
