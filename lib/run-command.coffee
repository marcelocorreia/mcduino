CommandRunnerView = require './command-runner-view'

module.exports =
  commandRunnerView: null

  activate: (state) ->
    @commandRunnerView = new CommandRunnerView(state.commandRunnerViewState)

  deactivate: ->
    @commandRunnerView.destroy()

  serialize: ->
    commandRunnerViewState: @commandRunnerView.serialize()
