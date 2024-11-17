# README

This file contains relevant information about installation and startup.

## Installation

#### Operating System

Our development is based on following environments.

```tex
Windows 10+
Ubuntu 22.04
```

To set up the game, first install `elm` and `Messenger` by running the commands below.

```bash
# Install elm
npm install -g elm
# Unix-based OS (MacOS / Linux)
pipx install -i https://pypi.python.org/simple elm-messenger>=0.3.6
# Or use pip on Windows:
pip install -i https://pypi.python.org/simple elm-messenger>=0.3.6
```

Then pull down the whole repository.

```bash
git clone git@github.com:Risc-lt/AMOM.git
```

## Usage

Firstly enter the root directory

```bash
cd ./AMOM
```

Since we've already written the makefile, you just need to press the following commands to compile the corresponding files.

```bash
make
```

To play the game, you can either use `Go Live` plugin in vscode or start a local server and run the service.

```bash
# python
python3 -m http.server 5500
# npm
http-server -p 5500
```

More detailed game rules can be seen in the game.

## License 

[SilverFocs Incubator Licence](https://focs.ji.sjtu.edu.cn/silverfocs/markdown/license)
