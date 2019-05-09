require "minitest/autorun"
require "./helpers/test_helper"

require "/../src/devman/command"

# mock_system("ProjectList")

class CommandTest < Minitest::Test
  @config_file = File.expand_path("~/.dmconfig")
  @projects_file = File.expand_path("~/.dmprojects")

  def initialize(arg)
    super(arg)

    clear_files
    Preferences.reset
    ProjectList.reset

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
  end

  def setup
  end

  def teardown
    ProjectList.output = [] of String
  end

  def test_edits_config_file
    File.write(@config_file, "editor: Sublime")
    Devman::Command.run ["-c", "editor", "Visual Studio Code"]
    file = File.read(@config_file)
    assert_equal "editor: Visual Studio Code\n", file
  end

  def test_creates_new_config_file_on_edit
    clear_files
    Devman::Command.run ["-c", "editor", "Visual Studio Code"]
    assert File.exists?(@config_file)
  end

  def test_opens_project
    Devman::Command.run ["-o", "Crystal Core"]
    assert_equal ["open -a Terminal /Users/chrislarsen/workspace/crystal", "open -a Terminal /Users/chrislarsen/workspace/crystal", "open -a Atom /Users/chrislarsen/workspace/crystal"], ProjectList.output
  end

  def test_adds_new_project
    Devman::Command.run ["-o", "Crystal Core"]
  end
end
