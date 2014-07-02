RunCommandView = require './run-command-view'
CommandRunnerView = require './command-runner-view'

module.exports =
  configDefaults:
    shellCommand: '/bin/bash'
    precedeCommandsWith: null
    snapCommandResultsToBottom: true

  runCommandView: null
  commandRunnerView: null

  activate: (state) ->
    @commandRunnerView = new CommandRunnerView()
    @runCommandView = new RunCommandView(@commandRunnerView)

  deactivate: ->
    @runCommandView.destroy()
    @commandRunnerView.destroy()

  serialize: ->
    runCommandViewState: @runCommandView.serialize()
