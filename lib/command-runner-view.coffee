{CompositeDisposable} = require 'atom'
{View} = require 'atom-space-pen-views'
{CommandRunner} = require './command-runner'
Utils = require './utils'

module.exports =
class CommandRunnerView extends View
  @content: ->
    @div class: 'command-runner', =>
      @header class: 'panel-heading', =>
        @span 'Command: '
        @span class: 'command-name', outlet: 'header'
      @div class: 'panel-body', outlet: 'outputContainer', =>
        @pre class: 'command-output', outlet: 'output'

  initialize: (runner) ->
    @panel = atom.workspace.addBottomPanel
      item: @,
      visible: false

    @subscriptions = new CompositeDisposable()
    @subscriptions.add = runner.onCommand (command) =>
      @setCommand(command)
    @subscriptions.add = runner.onStdout (data) =>
      @addOutput(data)
    @subscriptions.add = runner.onStderr (data) =>
      @addOutput(data)

  destroy: ->
    @subscriptions.destroy()

  show: ->
    @panel.show()

  hide: ->
    @panel.hide()

  isVisible: ->
    @panel.isVisible()



  atBottomOfOutput: ->
    @output[0].scrollHeight <= @output.scrollTop() + @output.outerHeight()

  scrollToBottomOfOutput: ->
    @output.scrollToBottom()



  setCommand: (command) ->
    @clearOutput()
    @header.text(command)
    @show()

  clearOutput: ->
    @output.empty()

  addOutput: (data) ->
    atBottom = @atBottomOfOutput()

    span = document.createElement('span')
    span.textContent = data
    @output.append(span)

    if atBottom
      @scrollToBottomOfOutput()
