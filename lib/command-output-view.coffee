{CompositeDisposable} = require 'atom'
{View} = require 'atom-space-pen-views'
{CommandRunner} = require './command-runner'
Utils = require './utils'

module.exports =
class CommandOutputView extends View
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
    @subscriptions.add = runner.onExit (code) =>
      @setExitCode(code)
    @subscriptions.add = runner.onKill (signal) =>
      @setKillSignal(signal)

  destroy: ->
    @subscriptions.destroy()

  show: ->
    @panel.show()
    @scrollToBottomOfOutput()

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

  addOutput: (data, classes) ->
    atBottom = @atBottomOfOutput()

    span = document.createElement('span')
    span.textContent = data

    if classes?
      for klass in classes
        span.classList.add(klass)

    @output.append(span)

    if atBottom
      @scrollToBottomOfOutput()

  setExitCode: (code) ->
    message = 'Command exited with status code ' + code.toString() + '\n'
    @addOutput(message, ['exit', 'exit-status'])

  setKillSignal: (signal) ->
    message = 'Command killed with signal ' + signal + '\n'
    @addOutput(message, ['exit', 'kill-signal'])
