def clear_files
  config_file = File.expand_path("~/.dmconfig")
  if File.exists?(config_file)
    File.delete(config_file)
  end
end
