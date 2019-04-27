require "minitest/autorun"

require "/../src/devman/project_list"

class ProjectList
  class_property output = [] of String
  def system(command : String, args = nil) : Bool
    @@output << command
    return true
  end
end

class ProjectListTest < Minitest::Test
  def initialize(arg)
    super(arg)

    @preferences = Preferences.load

    @yaml = <<-YAML
    projects:
      Crystal Core:
        folder: #{File.expand_path("~/workspace/crystal")}
        editor: Atom
        terminals: 2
      Minitest Crystal:
        folder: #{File.expand_path("~/workspace/minitest.cr")}
        terminals: 1
    YAML
    @projects = ProjectList.from_yaml(@yaml)
  end

  def teardown
    ProjectList.output = [] of String
  end

  def test_raise_error_on_dup
    error = assert_raises do
      @projects.dup
    end
    assert_equal "Can't dup instance of singleton ProjectList", error.message
  end

  def test_loads_projects_from_yaml
    projects = ProjectList.from_yaml(@yaml)
    assert_equal 2, projects.size
    first = projects["Crystal Core"]
    assert_equal File.expand_path("~/workspace/crystal"), first.folder
    assert_equal "Atom", first.editor
    assert_equal 2, first.terminals
  end

  def test_opens_project
    @projects.open("Crystal Core", @preferences)
    assert_equal ["open -a Terminal /Users/chrislarsen/workspace/crystal", "open -a Terminal /Users/chrislarsen/workspace/crystal", "open -a Atom /Users/chrislarsen/workspace/crystal"], ProjectList.output
  end

  def test_opens_with_defaults
    @projects.open("Minitest Crystal", @preferences)
    assert_equal ["open -a Terminal /Users/chrislarsen/workspace/minitest.cr", "open -a Atom /Users/chrislarsen/workspace/minitest.cr"], ProjectList.output
  end
end
