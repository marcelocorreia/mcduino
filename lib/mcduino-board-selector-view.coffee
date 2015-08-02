{$, View, SelectListView} = require 'atom-space-pen-views'
Utils = require './mcduino-utils'

module.exports =
class BoardSelectorView extends SelectListView
 initialize: ->
   super
   @addClass('overlay from-top')
   @setItems(Utils.getModelsList())
   @panel ?= atom.workspace.addModalPanel(item: this)
   @panel.show()
   @focusFilterEditor()

 viewForItem: (item) ->
   "<li>#{item}</li>"

 confirmed: (item) ->
   atom.config.set('mcduino.boardModel', item)
   atom.notifications.addSuccess("Board #{item} selected")
   @panel.hide()

 cancelled: ->
   @panel.hide()
