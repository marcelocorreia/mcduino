{$, View, TextEditorView} = require 'atom-space-pen-views'
{CommandRunner} = require './command-runner'
{CommandRunnerView} = require './command-runner-view'
Utils = require './utils'

module.exports =
class RunCommandView extends View
  @content: ->
    @div class: 'run-command padded overlay from-top', =>
      @subview 'commandEntryView', new TextEditorView(mini: true, placeholderText: 'rake spec')

  initialize: (commandRunnerView)->
    @commandRunnerView = commandRunnerView

    atom.workspaceView.command 'run-command:run', @toggle
    atom.workspaceView.command 'run-command:re-run-last-command', @reRunCommand
    atom.workspaceView.command 'run-command:toggle-panel', @togglePanel
    atom.workspaceView.command 'run-command:kill-last-command', @killLastCommand
    atom.workspaceView.on 'core:confirm', @runCommand
    atom.workspaceView.on 'core:cancel', @cancel

    @commandEntryView.on 'focusout', =>
      @cancel()


  serialize: ->

  runCommand: =>
    command = @commandEntryView.getModel().getText()

    unless Utils.stringIsBlank(command)
      @commandRunnerView.runCommand(command)
    @cancel()

  reRunCommand: (e)=>
    @commandRunnerView.reRunCommand(e)

  killLastCommand: =>
    @commandRunnerView.killCommand()

  cancel: =>
    if @hasParent()
      @restoreFocusedElement()
      @detach()
    else
      @commandRunnerView.hidePanel()

  storeFocusedElement: =>
    @previouslyFocused = $(':focus')

  restoreFocusedElement: =>
    if @previouslyFocused?
      @previouslyFocused.focus()
    else
      atom.workspaceView.focus()

  toggle: =>
    if @hasParent() then @cancel() else @attach()

  togglePanel: =>
    @commandRunnerView.togglePanel()

  attach: =>
    atom.workspaceView.append this
    @storeFocusedElement()
    @commandEntryView.focus()
    editor = @commandEntryView.getModel()
    editor.setSelectedBufferRange editor.getBuffer().getRange()

  destroy: =>
    @cancel()
