require "minitest/autorun"

require "/../src/project"

class ProjectTest < Minitest::Test
  def initialize(arg)
    super(arg)

    @yaml = <<-YAML
    folder: crystal
    editor: Atom
    terminals: 2
    YAML
  end

  def test_builds_from_yaml
    crystal = Project.from_yaml(@yaml)
    assert_equal "crystal", crystal.folder
    assert_equal "Atom", crystal.editor
    assert_equal 2, crystal.terminals
  end

  def test_edits_project
    project = Project.from_yaml(@yaml)
    project.edit("editor", "Sublime")
    assert_equal "Sublime", project.editor
  end

  def test_adds_existing_project
    project = Project.add("test")
  end
end
