require "yaml"

struct Preferences
  @@instance : Preferences?
  HOME_FOLDER = "/Users/#{`whoami`.chomp}/"

  YAML.mapping(
    project_folder: {type: String, default: HOME_FOLDER + "workspace"},
    editor: {type: String, default: "Atom"}
  )

  def self.load : Preferences
    if @@instance.nil?
      from_yaml("")
    else
      @@instance.not_nil!
    end
  end

  # Raises an Error to prevent cloning.
  def clone
    raise "Can't clone instance of singleton #{self.class}"
  end

  # Raises an Error to prevent duping.
  def dup
    raise "Can't dup instance of singleton #{self.class}"
  end
end
