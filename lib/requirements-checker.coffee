{BufferedProcess, Emitter, CompositeDisposable} = require 'atom'
# path = require 'path'
# pty = require 'pty.js'

module.exports =
class RequirementsChecker
  constructor: (@runner)->
    @subscriptions = new CompositeDisposable()

  @homeDirectory: ->
    process.env['HOME'] || process.env['USERPROFILE'] || '/'

  @workingDirectory: ->
    editor = atom.workspace.getActiveTextEditor()
    activePath = editor?.getPath()
    relative = atom.project.relativizePath(activePath)
    if activePath?
      relative[0] || path.dirname(activePath)
    else
      atom.project.getPaths()?[0] || @homeDirectory()

  getHomeDirectory: ->
    @runner.run('ls -l',false)
