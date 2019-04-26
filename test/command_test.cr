require "minitest/autorun"

require "/../src/devman/command"

class CommandTest < Minitest::Test
  @config_file = File.expand_path("~/.dmconfig")

  def teardown
    if File.exists?(@config_file)
      File.delete(@config_file)
    end
  end

  def test_edits_config_file
    File.write(@config_file, "editor: Sublime")
    Devman::Command.run ["-c", "editor", "Visual Studio Code"]
    file = File.read(@config_file)
    assert_equal "editor: Visual Studio Code\n", file
  end

  def test_creates_new_config_file_on_edit
    refute File.exists?(@config_file)
    Devman::Command.run ["-c", "editor", "Visual Studio Code"]
    assert File.exists?(@config_file)
  end

  def test_reveals_usage_for_editting_config
    usage = "Usage: devman -c [attribute] [new value]\n"
    response = `crystal run src/devman.cr -- -c`
    assert_equal usage, response
  end

  def test_returns_version_number
    response = `crystal run src/devman.cr -- -v`
    assert_equal "0.1.0\n", response
  end

  def test_returns_help_menu
    usage = Devman::Command::USAGE + "\n"
    response = `crystal run src/devman.cr -- -h`
    assert_equal usage, response
    response = `crystal run src/devman.cr -- --help`
    assert_equal usage, response
  end

  def test_returns_help_menu_from_no_args
    usage = Devman::Command::USAGE + "\n"
    response = `crystal run src/devman.cr`
    assert_equal usage, response
  end
end
