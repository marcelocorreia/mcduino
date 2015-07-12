{$, View, TextEditorView} = require 'atom-space-pen-views'
Utils = require './utils'

module.exports =
class NewProjectView extends View
  @content: ->
    @div class: 'command-entry', =>
      @subview 'commandEntryView', new TextEditorView
        mini: true,
        placeholderText: 'Enter path'


  initialize: (runner) ->
    @panel = atom.workspace.addModalPanel
      item: @,
      visible: false

    @runner = runner
    @subscriptions = atom.commands.add @element,
      'core:confirm': (event) =>
        @confirm()
        event.stopPropagation()
      'core:cancel': (event) =>
        @cancel()
        event.stopPropagation()

    @commandEntryView.on 'blur', =>
      @cancel()

  destroy: ->
    @subscriptions.destroy()

  show: ->
    @panel.show()

    @storeFocusedElement()
    @commandEntryView.getModel().setText('ino --help')
    @commandEntryView.focus()
    editor = @commandEntryView.getModel()
    editor.setSelectedBufferRange editor.getBuffer().getRange()
    command = @commandEntryView.getModel().getText()
    console.log(@runner.homeDirectory)
    #
    # @commandEntryView.getModel().setText('')

  hide: ->
    @panel.hide()

  isVisible: ->
    @panel.isVisible()


  getCommand: ->
    command = @commandEntryView.getModel().getText()
    if(!Utils.stringIsBlank(command))
      command

  cancel: ->
    @restoreFocusedElement()
    @hide()

  confirm: ->
    if(@getCommand())
      path = @getCommand()
      myCommand = 'mkdir ' + path + '; cd ' + path + '; ' + atom.config.get('mcduino.inoPath') + ' init -t blink; open -a Atom ' + path

      @runner.run(myCommand)

    @cancel()

  storeFocusedElement: ->
    @previouslyFocused = $(document.activeElement)

  restoreFocusedElement: ->
    @previouslyFocused?.focus?()