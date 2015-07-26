{$, View, TextEditorView} = require 'atom-space-pen-views'
Utils = require './utils'

module.exports =
class RequirementsView extends View
  @content: ->
    @div class: 'requirements', =>
      @h1 "Requirements Check"
      @ol =>
      @hr
      @h2 "Please check if the remaining requirements are installed available and available in the path ($PATH, %PATH%) and reload IDE"
      @div class: 'requirements-button',=>
        @button click: 'cancel','Ok I got it'


  initialize: () ->
    @panel = atom.workspace.addModalPanel
      item: @,
      visible: false


    # @subscriptions = atom.commands.add @element,
    #   'core:confirm': (event) =>
    #     @confirm()
    #     event.stopPropagation()
    #   'core:cancel': (event) =>
    #     @cancel()
    #     event.stopPropagation()

  addRequirement: (name) ->
    console.log name
    if(name !=null && !Utils.stringIsBlank(name))
      @find('ol').append "<li>#{name}</li>"

  destroy: ->
    @subscriptions.destroy()

  show: ->
    @panel.show()
    # @storeFocusedElement()
    # @commandEntryView.getModel().setText('dude.... missing stuff')
    # # @commandEntryView.focus()
    # editor = @commandEntryView.getModel()
    # editor.setSelectedBufferRange editor.getBuffer().getRange()
    # command = @commandEntryView.getModel().getText()


  hide: ->
    @panel.hide()

  isVisible: ->
    @panel.isVisible()


  # getCommand: ->
  #   command = @commandEntryView.getModel().getText()
  #   if(!Utils.stringIsBlank(command))
  #     command

  cancel: ->
    # @restoreFocusedElement()
    @hide()

  confirm: ->
    # if(@getCommand())
    #   path = @getCommand()
    #   myCommand = 'mkdir ' + path + '; cd ' + path + '; ' + atom.config.get('mcduino.inoPath') + ' init -t blink; open -a Atom ' + path

      # @runner.run(myCommand)

    # @cancel()

  # storeFocusedElement: ->
  #   @previouslyFocused = $(document.activeElement)
  #
  # restoreFocusedElement: ->
  #   @previouslyFocused?.focus?()
