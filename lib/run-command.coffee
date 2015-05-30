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

    @subscriptions = atom.commands.add 'atom-workspace',
      'run-command:run': => @run()
      'run-command:toggle-panel': => @togglePanel(),
      'run-command:kill-last-command': => @killLastCommand()

  deactivate: ->
    @runCommandView.destroy()
    @commandRunnerView.destroy()

  dispose: ->
    @subscriptions.dispose()



  run: ->
    @runCommandView.show()

  togglePanel: ->
    if @commandRunnerView.isVisible()
      @commandRunnerView.hide()
    else
      @commandRunnerView.show()

  killLastCommand: ->
    @runner.kill()
