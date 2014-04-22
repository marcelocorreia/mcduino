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
    atom.workspaceView.command 'run-command:kill-last-command', @killLastCommand
    @subscribe atom.workspaceView, 'core:confirm', @runCommand
    @subscribe atom.workspaceView, 'core:cancel', @cancel

    @commandEntryView.setPlaceholderText('rake spec')
    @commandEntryView.hiddenInput.on 'focusout', =>
      @cancel()


  serialize: ->

  runCommand: =>
    command = @commandEntryView.getEditor().getText()

    unless @stringIsBlank(command)
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
      @commandRunnerView.cancel()

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

  stringIsBlank: (str)->
    !str or /^\s*$/.test str

  destroy: =>
    @cancel()
