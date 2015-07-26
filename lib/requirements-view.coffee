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

  addRequirement: (name) ->
    console.log name
    if(name != null && !Utils.stringIsBlank(name))
      @find('ol').append "<li>#{name}</li>"

  destroy: ->
    @subscriptions.destroy()

  show: ->
    @panel.show()

  hide: ->
    @panel.hide()

  isVisible: ->
    @panel.isVisible()

  cancel: ->
    @hide()
