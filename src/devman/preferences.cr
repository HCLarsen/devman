require "yaml"

struct Preferences
  @@instance : Preferences?
  @@filename = File.expand_path("~/.dmconfig")

  YAML.mapping(
    project_folder: {type: String?, getter: false},
    editor: {type: String?, getter: false}
  )

  private def self.from_yaml(string_or_io : String | IO)
    super
  end

  private def initialize; end

  def project_folder : String
    @project_folder || File.expand_path("~/workspace")
  end

  def editor : String
    @editor || "Atom"
  end

  def self.preferences : Preferences
    if @@instance.nil?
      @@instnce = Preferences.load
    else
      @@instance.not_nil!
    end
  end

  # Loads the preferences from the config file.
  def self.load : Preferences
    content = File.exists?(@@filename) ? File.read(@@filename) : ""
    @@instnce = from_yaml(content)
  end

  def edit(attribute : String, value : String)
    case attribute
    when "project_folder"
      if value.starts_with? "/"
        @project_folder = value
      else
        @project_folder = File.expand_path("~/" + value)
      end
    when "editor"
      @editor = value
    end

    save
  end

  private def save
    yaml = to_yaml.lchop("---\n")
    File.write(@@filename, yaml)
  end

  # Raises an Error to prevent duping.
  def dup
    raise "Can't dup instance of singleton #{self.class}"
  end
end
