{BufferedProcess} = require 'atom'

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
    @process = new @processor @processParams()
    @returnCallback()

  kill: ->
    if @process?
      @process.kill()

module.exports =
  CommandRunner: CommandRunner
