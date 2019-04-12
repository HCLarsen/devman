require "minitest/autorun"

require "/../src/preferences"

class PreferencesTest < Minitest::Test
  def initialize(arg)
    super(arg)

    @preferences = Preferences.from_yaml("")
  end

  def test_default_folder_location
    whoami = `whoami`.chomp
    folder = "/Users/#{whoami}/workspace"
    assert_equal folder, @preferences.project_folder
  end

  def test_default_editor
    assert_equal "Atom", @preferences.editor
  end
end
