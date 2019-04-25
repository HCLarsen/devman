require "yaml"

struct Preferences
  @@instance : Preferences?

  YAML.mapping(
    project_folder: {type: String?, getter: false},
    editor: {type: String?, getter: false}
  )

  private def initialize
    @project_folder = File.expand_path("workspace")
    @editor = "Atom"
  end

  def project_folder : String
    @project_folder || File.expand_path("workspace")
  end

  def editor : String
    @editor || "Atom"
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

  def edit(attribute : String, value : String)
    case attribute
    when "project_folder"
      @project_folder = value
    when "editor"
      @editor = value
    end
  end

  def save
    yaml = to_yaml
    File.write(File.expand_path("~/.dmconfig"), yaml)
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
