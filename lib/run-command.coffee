RunCommandView = require './run-command-view'

module.exports =
  runCommandView: null

  activate: (state) ->
    @runCommandView = new RunCommandView(state.runCommandViewState)

  deactivate: ->
    @runCommandView.destroy()

  serialize: ->
    runCommandViewState: @runCommandView.serialize()
