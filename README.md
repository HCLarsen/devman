# Development Management Tool

This is my development management tool. A simple command line interface that automates certain features. It's partially inspired by Webpack, but unlike Webpack, it can be configured and used with any language or platform.

## Installation

TODO: Write installation instructions here

## Usage

Development Manager is a command line tool with three main functions. Creating a new project, opening an existing project, or pulling a new project from a remote repository.

You may also change the configuration for the tool, or for the individual projects using either the command line interface, or directly modifying the YAML files that those preferences are stored in. Since the project specific configurations can likely change from user to user on a multi-person project, these config files aren't located in the project directly, like the gitignore, or CI config files. These are all stored in the projects.yml file in the user's home directory.

### Creating a new project

You can create a new project using the -n(--new) flag. Format for this flag is `devman -n [project ID] [language/platform] [project name]`. The project ID is the name used by DevMan to keep track of this project, while the project name is what will be used when creating the project in your chosen language or framework. If the project name is omitted, then it is taken to be the same as the project ID, but in lowercase. If you wish your project name and folder to be in uppercase, you must specify that as the project name.

However, if this is the case, any spaces in the project ID will generate an error, as most software frameworks don't allow spaces in the project names. Otherwise, the project ID may have spaces, as long as the entire ID is wrapped in single or double quotes. The first example will create the project, however the second example will generate an error.

```
devman -n "Test Project" Crystal test
```
```
devman -n "Test Project" Crystal
```

### Adding an existing project to the devman configuration

The Development Manager keeps track of projects through an internal list. You can add an existing project on your computer to this list using the -a(--add) flag. The format for this flag is `devman -a [project ID] [project folder]`. As with the -n flag, if the project folder is omitted, then it is taken to assume that the project folder is the lowercase of the project ID. As such, devman will return an error if there are any spaces in the project ID.

```
devman - a "Test Project" test
```

### Opening an existing project

Any project that you've created through DevMan, or added to the DevMan project list, can be opened using the -o(--open) flag. As the DevMan tool already has all necessary information on the project, all that's needed to open it is the project ID.
```
devman -o "Test Project"
```

### Adding a remote project

TODO: Write usage instructions here about adding a project from a remote repo.

### Configuring options and preferences

Changing overall configuration settings is done with the -c(--config) flag. Format for this function is `devman -c [project ID] [setting] [value]`
```
devman -c dir Workspace
```

### Configuring project settings

The configuration of each project can be done with the -e(--edit) flag. The format for this function is `devman -e [project ID] [setting] [value]`, similar to the global config.
```
devman -e "Test Project" editor "Visual Studio Code"
```

## Development

Very preliminary right now. Mostly I'm still designing how it's going to work.

## Contributing

1. Fork it (<https://github.com/your-github-user/devman/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Chris Larsen](https://github.com/your-github-user) - creator and maintainer
