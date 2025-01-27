# Deployment Guide

This guide will get your process up and running on AO, providing step-by-step instructions for deploying your application.

## Prerequisites

Before deploying, ensure you have Node.js installed. You can use the following command to set up your environment automatically:

```bash
make setup
```

Or refer to the [Node.js Installation Guide](misc/install_npm.md).

## Installing AOS and Dependencies

To install AOS along with all necessary dependencies, run the following command:

```bash
make install
```

This command will set up everything you need, including AOS, LuaRocks, and Node.js dependencies.

## Build the Project

Run the following command to build the project:

```bash
make build
```

## Deployment

### AOS Native

Start AOS with the following command:

```bash
aos
```

#### Load the Bundled Process

To load the bundled process, execute:

```bash
.load process.lua
```

### Makefile

As an alternative to the manual steps above, you can use the following command to automate the deployment process:

```bash
make deploy
```

This command will start AOS and load the bundled process automatically.