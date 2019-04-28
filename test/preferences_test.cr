require "minitest/autorun"
require "./helpers/test_helper"

require "/../src/devman/preferences"

class PreferencesTest < Minitest::Test
  @config_file = File.expand_path("~/.dmconfig")

  def initialize(arg)
    super(arg)

    clear_files
    @preferences = Preferences.load
  end

  def create_file
    File.write(@config_file, "project_folder: #{File.expand_path("~/developer")}\neditor: Sublime")
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
    folder = File.expand_path("~/workspace")
    assert_equal folder, @preferences.project_folder
  end

  def test_default_editor
    assert_equal "Atom", @preferences.editor
  end

  def test_reads_config_file
    create_file
    assert_equal File.expand_path("~/developer"), @preferences.project_folder
    assert_equal "Sublime", @preferences.editor
  end

  def test_edits_values
    assert_equal File.expand_path("~/workspace"), @preferences.project_folder
    assert_equal "Atom", @preferences.editor
    @preferences.edit("editor", "Sublime")
    assert_equal "Sublime", @preferences.editor
    @preferences.edit("project_folder", "developer")
    assert_equal File.expand_path("~/developer"), @preferences.project_folder
  end

  def test_differentiates_absolute_and_relative_paths
    @preferences.edit("project_folder", "/software")
    assert_equal "/software", @preferences.project_folder
    @preferences.edit("project_folder", "software")
    assert_equal File.expand_path("~/software"), @preferences.project_folder
  end

  def test_saves_only_modified_values
    @preferences.edit("editor", "Sublime")
    assert_equal "Sublime", @preferences.editor
    assert File.exists?(@config_file)
    file = File.read(@config_file)
    assert_equal "editor: Sublime\n", file
  end
end
