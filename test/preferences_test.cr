require "minitest/autorun"

require "/../src/preferences"

class PreferencesTest < Minitest::Test
  def initialize(arg)
    super(arg)

    @preferences = Preferences.load
  end

  def test_raise_error_on_clone
    error = assert_raises do
      @preferences.clone
    end
    assert_equal "Can't clone instance of singleton Preferences", error.message
  end

  def test_raise_error_on_dup
    error = assert_raises do
      @preferences.dup
    end
    assert_equal "Can't dup instance of singleton Preferences", error.message
  end

  def test_default_project_folder_location
    whoami = `whoami`.chomp
    folder = "/Users/#{whoami}/workspace"
    assert_equal folder, @preferences.project_folder
  end

  def test_default_editor
    assert_equal "Atom", @preferences.editor
  end
end
