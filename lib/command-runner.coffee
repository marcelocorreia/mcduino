{BufferedProcess} = require 'atom'
Utils = require './utils'

class CommandRunner
  processor: BufferedProcess
  commandResult: ''

  constructor: (command, callback)->
    @command = command
    @callback = callback

  collectResults: (output) =>
    @commandResult += output.toString()
    @returnCallback()

  exit: (code) =>
    @returnCallback()

  processParams: ->
    command: if atom.config.get("run-command.shellCommand")? then atom.config.get("run-command.shellCommand") else '/bin/bash'
    args: ['-c', @addPrecedentCommand(@command), '-il']
    options:
      cwd: atom.project.getPaths()[0]
    stdout: @collectResults
    stderr: @collectResults
    exit: @exit

  returnCallback: =>
    @callback(@command, @commandResult)

  runCommand: ->
    @commandResult = ''
    @process = new @processor @processParams()
    @returnCallback()

  kill: ->
    if @process?
      @process.kill()

  addPrecedentCommand: (command)=>
    precedent = atom.config.get 'run-command.precedeCommandsWith'

    if precedent? and !Utils.stringIsBlank(precedent)
      @joinCommands [precedent, command]
    else
      command

  joinCommands: (commands)=>
    commands.join(' && ')

module.exports =
  CommandRunner: CommandRunner
