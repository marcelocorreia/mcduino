# MCduino Arduino plugin for Atom
Arduino support in [Atom](http://atom.io).

Originally derived from Kyle Lacy's [run-command](https://github.com/kylewlacy/run-command).

Toolbar powered by https://github.com/suda/tool-bar

---
###Currently for Arduino 1.0.x only and Unix based systems
- MacOS (Tested on 10.10.14)
- Linux (Not tested)
- FreeBSD (Not tested)
- OpenBSD (Not tested)

![Screenshot](https://raw.githubusercontent.com/marcelocorreia/mcduino/master/screenshots/mcduino-screenshot.png)

# ROADMAP
- ~~Read boards from Arduino's boards.txt~~
- Improve test coverage
- Read serial ports from OS (Explore Ino's options)
- ~~Add compiler flags settings~~
- Linux support
- Support for Arduino 1.6.x

# Resources & Docs

### Dependencies
- [Arduino IDE 1.0.x](http://arduino.cc)
- [Python](https://www.python.org)
- [Ino](http://inotool.org)
- [Suda tool-bar](https://github.com/suda/tool-bar) (optional)

##Installing MCduino
- Install Arduino and Inotool (Instructions below)


### Download Arduino 1.0.0
  - [MacOS](http://arduino.cc/download.php?f=/arduino-1.6.3-macosx.zip)
  - [Linux64](http://arduino.cc/download.php?f=/arduino-1.6.3-linux64.tar.xz)
  - [Linux32](http://arduino.cc/download.php?f=/arduino-1.6.3-linux32.tar.xz)

---
## Installing Arduino
![](https://www.arduino.cc/img/GenuinoHeader.svg)
###MacOS
1. Download arduino. ([MacOS](http://arduino.cc/download.php?f=/arduino-1.6.3-macosx.zip) |  [Linux64](http://arduino.cc/download.php?f=/arduino-1.6.3-linux64.tar.xz) | [Linux32](http://arduino.cc/download.php?f=/arduino-1.6.3-linux32.tar.xz))
2. Copy the Arduino application into the Applications folder (or elsewhere on your computer)

If you're using an Arduino Uno or Mega 2560, you don't have any drivers to install. Skip ahead to the next step.
If you're using an older board (Duemilanove, Diecimila, or any board with an FTDI driver chip.

You will need to install the drivers for the FTDI chip on the board. You need to download the latest version of the drivers from the [FTDI website](http://www.ftdichip.com/Drivers/VCP.htm). One downloaded, double click the package, and follow the instructions in the installer. You'll need to restart your computer after installing the drivers.

---

###Linux
Installing Arduino on Linux, for more detailed instructions, pick your distribution:


[ArchLinux](http://playground.arduino.cc/Linux/ArchLinux)

[CentOS]( http://playground.arduino.cc/Linux/CentOS6)

[Debian](http://playground.arduino.cc/Linux/Debian)

[Fedora](http://playground.arduino.cc/Linux/Fedora)

[Gentoo](http://playground.arduino.cc/Linux/Gentoo)

[Mageia](http://playground.arduino.cc/Linux/Mageia)

[MEPIS](http://playground.arduino.cc/Linux/MEPIS)

[Mint](http://playground.arduino.cc/Linux/Mint)

[openSUSE](http://playground.arduino.cc/Linux/OpenSUSE)

[Puppy](http://playground.arduino.cc/Linux/Puppy)

[Pussy](http://playground.arduino.cc/Linux/Pussy)

[Slackware](http://playground.arduino.cc/Linux/Slackware)

[Ubuntu](http://playground.arduino.cc/Linux/Ubuntu)

[Xandros](http://playground.arduino.cc/Linux/Xandros)

[All "the hard way"](http://playground.arduino.cc/Linux/All)


---

## Inotool Resources and Install Guide
![Inotool logo](http://inotool.org/_static/logo.png)

###Ino

Ino is a command line toolkit for working with Arduino hardware

It allows you to:

Quickly create new projects
Build a firmware from multiple source files and libraries
Upload the firmware to a device
Perform serial communication with a device (aka serial monitor)
Ino may replace Arduino IDE UI if you prefer to work with command line and an editor of your choice or if you want to integrate Arduino build process to 3-rd party IDE.

Ino is based on make to perform builds. However Makefiles are generated automatically and you’ll never see them if you don’t want to.

Features

Simple. No build scripts are necessary.
Out-of-source builds. Directories with source files are not cluttered with intermediate object files.
Support for \*.ino and \*.pde sketches as well as raw \*.c and \*.cpp.
Support for Arduino Software versions 1.x as well as 0.x.
Automatic dependency tracking. Referred libraries are automatically included in the build process. Changes in \*.h files lead to recompilation of sources which include them.
Pretty colorful output.
Support for all boards that are supported by Arduino IDE.
Fast. Discovered tool paths and other stuff is cached across runs. If nothing has changed, nothing is build.
Flexible. Support for simple ini-style config files to setup machine-specific info like used Arduino model, Arduino distribution path, etc just once.

### Installation
From source:
- [Download latest source tarball](http://pypi.python.org/pypi/ino/#downloads)
- Or clone it from GitHub: git clone git://github.com/amperka/ino.git
- Do make install to perform installation under /usr/local
- Or see INSTALL for instructions on changing destination directory

With Python setup tools:
- Either pip install ino
- Or easy_install ino


### Requirements
- Python 2.6+
- Arduino IDE distribution


### Limitations
As for current version, ino works only in Linux and MacOS. However it was created with other OS users in mind, so it will eventually get full cross-platform support. Help from Windows-developers is much appreciated.

### Getting Help
- Take a look at [Quick start tutorial](http://inotool.org/quickstart).
- Run ino --help.
- Post [issues to GitHub](http://github.com/amperka/ino/issues).
