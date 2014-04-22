{$, View, EditorView} = require 'atom'
{CommandRunner} = require './command-runner'
{CommandRunnerView} = require './command-runner-view'

module.exports =
class RunCommandView extends View
  @content: ->
    @div class: 'run-command overlay from-top', =>
      @subview 'commandEntryView', new EditorView(mini: true)

  initialize: (commandRunnerView)->
    @commandRunnerView = commandRunnerView

    atom.workspaceView.command "run-command:run", @toggle
    atom.workspaceView.command "run-command:re-run-last-command", @reRunCommand
    atom.workspaceView.command "run-command:toggle-panel", @togglePanel
    @subscribe atom.workspaceView, 'core:confirm', @confirm
    @subscribe atom.workspaceView, 'core:cancel', @cancel

    @commandEntryView.setPlaceholderText('rake spec')
    @commandEntryView.hiddenInput.on 'focusout', =>
      @cancel()


  serialize: ->

  storeFocusedElement: =>
    @previouslyFocused = $(':focus')

  restoreFocusedElement: =>
    if @previouslyFocused?
      @previouslyFocused.focus()
    else
      atom.workspaceView.focus()

  toggle: =>
    if @hasParent() then @cancel() else @attach()

  reRunCommand: (e)=>
    @commandRunnerView.reRunCommand(e)

  togglePanel: =>
    @commandRunnerView.togglePanel()

  attach: =>
    atom.workspaceView.append this
    @storeFocusedElement()
    @commandEntryView.focus()

  confirm: =>
    command = @commandEntryView.getEditor().getText()
    @commandRunnerView.runCommand(command)
    @cancel()

  cancel: =>
    if @hasParent()
      @restoreFocusedElement()
      @detach()
    else
      @commandRunnerView.cancel()

  destroy: ->
    @cancel()
