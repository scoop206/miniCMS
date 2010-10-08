class DuMigrationUtils
  
  def self.convert_dirs_filenames_to_erb(directory, is_partial = false)
    Dir.new(directory).each do |file|
      unless file =~ /^\./
        
        unless is_partial
          new_file_name = file.split('.shtml').first + '.html.erb'
        else
          new_file_name = file.split('.html').first + '.html.erb'
          new_file_name = "_" + new_file_name
        end
        
        # new_file_name = ""
        # new_file_name.replace(file)
        
        #replace all the hyphens with underscores
        new_file_name.gsub!('-','_')
        
        new_path = File.join(directory, new_file_name)
        old_path = File.join(directory, file)
        
        File.rename(old_path, new_path)
      end
    end
  end

end