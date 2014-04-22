{$, View} = require 'atom'
{CommandRunner} = require './command-runner'

module.exports =
class CommandRunnerView extends View
  @content: ->
    @div class: "inset-panel panel-bottom run-command", =>
      @div class: "panel-heading", =>
        @span 'Command: '
        @span outlet: 'header'
      @div class: "panel-body padded results", =>
        @pre '', outlet: 'results'

  destroy: ->
    delete @commandRunner
    @detach()

  render: (command, results)=>
    @header.text(command)
    @results.text(results)

  hidePanel: =>
    @detach() if @hasParent()

  showPanel: =>
    atom.workspaceView.prependToBottom(this) unless @hasParent()

  togglePanel: =>
    if @hasParent() then @hidePanel() else @showPanel()

  runCommand: (command)->
    if @commandRunner?
      @commandRunner.kill()
      delete @commandRunner

    @commandRunner = new CommandRunner(command, @render)
    @commandRunner.runCommand()
    @showPanel()

  reRunCommand: (e)=>
    if @commandRunner?
      @commandRunner.kill()

      @commandRunner.runCommand()
      @showPanel()
    else
      e.abortKeyBinding()

  killCommand: (e) =>
    if @commandRunner?
      @commandRunner.kill()
