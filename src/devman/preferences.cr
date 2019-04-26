require "yaml"

struct Preferences
  @@instance : Preferences?
  @@filename = File.expand_path("~/.dmconfig")

  YAML.mapping(
    project_folder: {type: String?, getter: false},
    editor: {type: String?, getter: false}
  )

  private def initialize; end

  def project_folder : String
    @project_folder || File.expand_path("workspace")
  end

  def editor : String
    @editor || "Atom"
  end

  # Loads the preferences from the config file.
  def self.load : Preferences
    if @@instance.nil?
      content = File.exists?(@@filename) ? File.read(@@filename) : ""
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

    save
  end

  private def save
    yaml = to_yaml.lchop("---\n")
    File.write(@@filename, yaml)
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
