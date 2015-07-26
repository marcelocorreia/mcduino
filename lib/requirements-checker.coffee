{BufferedProcess, Emitter, CompositeDisposable} = require 'atom'
RequirementsView = require './requirements-view'
shell = require 'shelljs/global'
fs = require('fs');
Utils = require './utils'

module.exports =
class RequirementsChecker
  constructor: (@runner)->
    @subscriptions = new CompositeDisposable()
    @reqView = new RequirementsView()



  check:(executable) ->
    if not which executable
      @reqView.addRequirement('<span class="red">' + executable + ' not found in path.</span>')
      missingStuff = true
    else
      @reqView.addRequirement('<span class="green">' + executable+' found in path.</span>')

    @reqView.show() if missingStuff

  checkItAll: ->
    @check appl for appl in ['python', 'ino']
