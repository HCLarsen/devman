require "minitest/autorun"

class E2ETEST < Minitest::Test
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
