{CompositeDisposable} = require 'atom'
# path = require 'path'
# pty = require 'pty.js'
shell = require 'shelljs/global'

module.exports =
class ShellRunner
  constructor: ->
    @subscriptions = new CompositeDisposable()

  run: ->
    @shell.exec 'ls'
