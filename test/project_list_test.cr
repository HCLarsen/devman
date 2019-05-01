require "minitest/autorun"
require "./helpers/test_helper"

require "/../src/devman/project_list"

mock_system("ProjectList")

class ProjectListTest < Minitest::Test
  @projects_file = File.expand_path("~/.dmprojects")

  def initialize(arg)
    super(arg)

    clear_files
    @preferences = Preferences.load

    yaml = <<-YAML
    projects:
      Crystal Core:
        folder: #{File.expand_path("~/workspace/crystal")}
        editor: Atom
        terminals: 2
      Minitest Crystal:
        folder: #{File.expand_path("~/workspace/minitest.cr")}
        terminals: 1
    YAML
    File.write(@projects_file, yaml)
    @projects = ProjectList.load
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

  def test_reads_projects_file
    assert_equal 2, @projects.size
    first = @projects["Crystal Core"]
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
