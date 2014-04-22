{BufferedProcess} = require 'atom'

class CommandRunner
  process: BufferedProcess
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
    command: '/bin/bash'
    args: ['-c', @command]
    options:
      cwd: atom.project.getPath()
    stdout: @collectResults
    stderr: @collectResults
    exit: @exit

  returnCallback: =>
    @callback(@command, @commandResult)

  runCommand: ->
    @commandResult = ''
    new @process @processParams()
    @returnCallback()

module.exports =
  CommandRunner: CommandRunner
