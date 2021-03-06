require "minitest/autorun"
require "./helpers/test_helper"

require "/../src/devman/project_list"

mock_system("ProjectList")

class ProjectListTest < Minitest::Test
  @projects_file = File.expand_path("~/.dmprojects")

  def initialize(arg)
    super(arg)

    Preferences.reset
    ProjectList.reset

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
    File.write(@projects_file, @yaml)
    @projects = ProjectList.load
    clear_files
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

  def test_adds_new_project_with_default_folder
    @projects.add("Devman")
    devman = @projects["Devman"]
    assert_equal "devman", devman.folder
    assert File.exists?(@projects_file)
    file = File.read(@projects_file)
    assert_equal @yaml + "\n  Devman:\n    folder: devman\n", file
  end

  def test_adds_new_project_with_custom_settings
    @projects.add("Devman", "devman-project")
    devman = @projects["Devman"]
    assert_equal "devman-project", devman.folder
  end

  def test_raises_error_on_duplicate_project_name
    error = assert_raises do
      @projects.add("Crystal Core", "crystal")
    end
    assert_equal "Project titled 'Crystal Core' already exists", error.message
  end

  def test_raises_error_for_default_folder_with_space
    error = assert_raises do
      @projects.add("Devman Project")
    end
    assert_equal "Whitespace not allowed in folder name", error.message
  end

  def test_opens_project
    @projects.open("Crystal Core")
    assert_equal ["open -a Terminal /Users/chrislarsen/workspace/crystal", "open -a Terminal /Users/chrislarsen/workspace/crystal", "open -a Atom /Users/chrislarsen/workspace/crystal"], ProjectList.output
  end

  def test_opens_with_defaults
    @projects.open("Minitest Crystal")
    assert_equal ["open -a Terminal /Users/chrislarsen/workspace/minitest.cr", "open -a Atom /Users/chrislarsen/workspace/minitest.cr"], ProjectList.output
  end
end
