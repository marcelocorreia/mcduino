{$, View, EditorView} = require 'atom'
{CommandRunner} = require './command-runner'
{CommandRunnerView} = require './command-runner-view'

module.exports =
class RunCommandView extends View
  @content: ->
    @div class: 'run-command overlay from-top', =>
      @subview 'commandEntryView', new EditorView(mini: true)

  initialize: (state)->
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

  reRunCommand: ->
    console.log 're-run'

  togglePanel: ->
    console.log 'toggle panel'

  attach: =>
    atom.workspaceView.append this
    @storeFocusedElement()
    @commandEntryView.focus()

  confirm: =>
    console.log 'confirm'
    @cancel()

  cancel: =>
    @restoreFocusedElement()
    @detach() if @hasParent()

  destroy: ->
    @cancel()
