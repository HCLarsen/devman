require "yaml"

class Preferences
  @home_folder = "/Users/#{`whoami`.chomp}/"

  YAML.mapping(
    project_folder: {type: String, default: @home_folder + "workspace"},
    editor: {type: String, default: "Atom"}
  )
end
