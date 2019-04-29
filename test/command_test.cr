require "minitest/autorun"
require "./helpers/test_helper"

require "/../src/devman/command"

class CommandTest < Minitest::Test
  @config_file = File.expand_path("~/.dmconfig")

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
end
