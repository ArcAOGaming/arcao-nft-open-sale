# Development Guide

## Platform-Specific Prerequisites

### Windows Users
Windows users need to install WSL (Windows Subsystem for Linux) first. Please follow the [WSL Installation Guide](misc/install_wsl.md) before proceeding.

### macOS Users
macOS users need to install Homebrew first. Please follow the [Homebrew Installation Guide](misc/install_homebrew.md) before proceeding.

## Prerequisites

Ensure you have Node.js and LuaRocks installed on your system. You can use the following command to set up your environment automatically:

```bash
make setup
```

Or follow the instructions in the respective guides:

- [Node.js Installation Guide](misc/install_npm.md)
- [LuaRocks Installation Guide](misc/install_luarocks.md)

### Installing Project Dependencies

To install the project's dependencies, simply run:

```bash
make install
```

### Building the Project

To build the project, use:

```bash
make build
```

### Running Unit Tests

To run the unit test suite, execute:

```bash
make test
```

This project uses [Busted](https://olivinelabs.com/busted/) for testing. All test files should:
- Be placed in the `spec` directory
- Have a filename ending in `_spec.lua`
- Use BDD-style `describe` and `it` blocks
