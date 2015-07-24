{BufferedProcess, Emitter, CompositeDisposable} = require 'atom'
RequirementsView = require './requirements-view'
shell = require 'shelljs/global'

module.exports =
class RequirementsChecker
  constructor: (@runner)->
    @subscriptions = new CompositeDisposable()
    @reqView = new RequirementsView()



  check:(executable) ->
    if not which executable
      @reqView.addRequirement('<span class="red">'+executable+'</span>')
    else
      @reqView.addRequirement('<span class="green">'+executable+'</span>')

    @reqView.show()

  checkItAll: ->
    @check appl for appl in ['python', 'inos']
