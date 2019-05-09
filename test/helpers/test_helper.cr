class ProjectList
  def self.reset
    @@instance = nil
  end
end

macro mock_system(class_name)
  class {{class_name.id}}
	  class_property output = [] of String
    def system(command : String, args = nil) : Bool
      @@output << command
      return true
    end
  end
end

def clear_files
  config_file = File.expand_path("~/.dmconfig")
  projects_file = File.expand_path("~/.dmprojects")

  if File.exists?(config_file)
    File.delete(config_file)
  end

  if File.exists?(projects_file)
    File.delete(projects_file)
  end
end
