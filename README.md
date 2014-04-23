# "Run Command" for Atom

Execute any arbitrary command in [Atom](http://atom.io). Derived from Phil Nash's [Ruby Quick Test](https://github.com/philnash/ruby-quick-test).

# Usage
Smack `ctrl-r` to open up this:

!['Run Command' dialog](screenshots/run-command.gif)

Enter a command, and whack `enter` to run it:

![Running `rake spec`](screenshots/run.gif)

Clack down `cmd-ctrl-r` to run it again:

![Re-running `rake spec`](screenshots/re-run.gif)

Together, these let you do this:

![Bernhardt-style TDD](screenshots/tdd.gif)

(You can also toggle the command output with `cmd-ctrl-x`, or kill the last command with `cmd-ctrl-alt-x`)

# TODO
- ANSI color codes
- Setting the working directory
- Resizable output
- Editor variables (such as `$ATOM_PROJECT` for the current project directory)
