{ContentDisposable} = require 'atom'
CommandRunner = require './command-runner'
RunCommandView = require './run-command-view'
CommandRunnerView = require './command-runner-view'

module.exports =
  configDefaults:
    shellCommand: '/bin/bash'
    precedeCommandsWith: null
    snapCommandResultsToBottom: true

  activate: (state) ->
    @runner = new CommandRunner()

    @commandRunnerView = new CommandRunnerView(@runner)
    @runCommandView = new RunCommandView(@runner)

    @runner.onCommand (command) =>
      @saveLastCommand(command)

    @subscriptions = atom.commands.add 'atom-workspace',
      'run-command:run': => @run()
      'run-command:re-run-last-command': => @reRunLastCommand(),
      'run-command:toggle-panel': => @togglePanel(),
      'run-command:kill-last-command': => @killLastCommand()

  deactivate: ->
    @runCommandView.destroy()
    @commandRunnerView.destroy()

  dispose: ->
    @subscriptions.dispose()



  saveLastCommand: (command) ->
    @lastCommand = command



  run: ->
    @runCommandView.show()

  reRunLastCommand: ->
    if @lastCommand?
      @runner.run(@lastCommand)

  togglePanel: ->
    if @commandRunnerView.isVisible()
      @commandRunnerView.hide()
    else
      @commandRunnerView.show()

  killLastCommand: ->
    @runner.kill()
