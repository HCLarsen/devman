require "yaml"

struct Preferences
  @@instance : Preferences?

  YAML.mapping(
    project_folder: {type: String, default: File.expand_path("workspace")},
    editor: {type: String, default: "Atom"}
  )

  private def initialize
    @project_folder = File.expand_path("workspace")
    @editor = "Atom"
  end

  # Loads the preferences from the config file.
  def self.load : Preferences
    filename = ".dmconfig"
    if @@instance.nil?
      content = File.exists?(filename) ? File.read(filename) : ""
      from_yaml(content)
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
