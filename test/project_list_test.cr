require "minitest/autorun"

require "/../src/devman/project_list"

class ProjectListTest < Minitest::Test
  def initialize(arg)
    super(arg)

    yaml = <<-YAML
    ---
    projects:
      Crystal Core:
        folder: crystal
        editor: Atom
        terminals: 2
      Minitest Crystal:
        folder: minitest.cr
        editor: Atom
        terminals: 1
    YAML
    @projects = ProjectList.from_yaml(yaml)
  end

  def test_raise_error_on_dup
    error = assert_raises do
      @projects.dup
    end
    assert_equal "Can't dup instance of singleton ProjectList", error.message
  end

  def test_loads_projects_from_yaml
    yaml = <<-YAML
    ---
    projects:
      Crystal Core:
        folder: crystal
        editor: Atom
        terminals: 2
      Minitest Crystal:
        folder: minitest.cr
        editor: Atom
        terminals: 1
    YAML
    projects = ProjectList.from_yaml(yaml)
    assert_equal 2, projects.size
    first = projects["Crystal Core"]
  end
end
