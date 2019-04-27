require "yaml"

struct Project
  YAML.mapping(
    folder: String,
    editor: String?,
    terminals: Int32?,
  )

  def initialize(@folder, @editor, @terminals)
  end

  def self.add(folder, editor = nil, terminals = nil)
    self.new(folder, editor, terminals)
  end

  def edit(attribute : String, value : String)
    case attribute
    when "folder"
      if value.starts_with? "/"
        @folder = value
      else
        @folder = File.expand_path("~/" + value)
      end
    when "editor"
      @editor = value
    when "terminals"
      @terminals = value.to_i
    else
      return false
    end

    return true
  end
end
