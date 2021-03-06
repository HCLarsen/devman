class ProjectList
  @@instance : ProjectList?
  @@filename = File.expand_path("~/.dmprojects")

  YAML.mapping(
    projects: { type: Hash(String, Project), default: {} of String => Project }
  )

  private def self.from_yaml(string_or_io : String | IO)
    super
  end

  private def initialize
    @projects = {} of String => Project
  end

  def size : Int32
    @projects.size
  end

  def [](key : String)
    @projects[key]
  end

  # Raises an Error to prevent duping.
  def dup
    raise "Can't dup instance of singleton #{self.class}"
  end

  def self.load : ProjectList
    if @@instance.nil?
      content = File.exists?(@@filename) ? File.read(@@filename) : ""
      @@instance = from_yaml(content)
    else
      @@instance.not_nil!
    end
  end

  def add(name : String, folder = nil)
    unless @projects.has_key? name
      folder = folder || name.downcase
      if folder =~ /\s/
        raise "Whitespace not allowed in folder name"
      end
      @projects[name] = Project.new(folder)
      save
    else
      raise "Project titled '#{name}' already exists"
    end
  end

  def open(name : String)
    preferences = Preferences.load
    project = @projects[name]
    folder = project.folder
    editor = project.editor || preferences.editor
    terminals = project.terminals || 0
    terminals.times do
      system("open -a Terminal #{folder}")
    end
    system("open -a #{editor} #{folder}")
  end

  private def save
    yaml = to_yaml.lchop("---\n")
    File.write(@@filename, yaml)
  end
end
