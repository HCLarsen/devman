module Devman
  VERSION = YAML.parse(File.read("shard.yml"))["version"].as_s
end

class Devman::Command
  USAGE = <<-USAGE
    Usage: devman [command] [arguments]

    Command:
        -o, --open        open project
        -e, --editor      edit project settings
        -a, --add         add local project to Devman settings
        -g, --git         add and download project from remote repo
        -n, --new         create new project from scratch
        -h, --help        show this help
        -v, --version     show version
  USAGE

  def self.run(options = ARGV)
    new(options)
  end

  def initialize(options : Array(String))
    @preferences = Preferences.load
    @projects = ProjectList.load

    arg = options.shift?
    case arg
    when "-a", "--add"
      add_project(options)
    when "-o", "--open"
      open_project(options)
    when "-c", "--config"
      edit_config(options)
    when "-v", "--version"
      puts Devman::VERSION
    when "-h", "--help", nil
      puts USAGE
    end
  end

  def add_project(args)
    begin
      @projects.add(args[0], args[1]?)
    rescue ex
      puts ex.message
    end
  end

  def open_project(args)
    if args.size == 1
      @projects.open(args[0])
    end
  end

  def edit_config(args)
    if args.size == 2
      @preferences.edit(args[0], args[1])
    else
      puts "Usage: devman -c [attribute] [new value]"
    end
  end
end
