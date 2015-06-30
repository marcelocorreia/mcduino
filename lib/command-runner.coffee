{BufferedProcess, Emitter, CompositeDisposable} = require 'atom'
path = require 'path'

module.exports =
class CommandRunner
  constructor: ->
    @subscriptions = new CompositeDisposable()
    @emitter = new Emitter()

  spawnProcess: (command) ->
    @process = new BufferedProcess
      command: atom.config.get('run-command.shellCommand') || '/bin/bash'
      args: ['-c', command]
      options:
        cwd: @constructor.workingDirectory()
      stdout: (data) =>
        @emitter.emit('data', data)
      stderr: (data) =>
        @emitter.emit('data', data)
      exit: =>
        @emitter.emit('exit')

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

  onCommand: (handler) ->
    @emitter.on 'command', handler
  onData: (handler) ->
    @emitter.on 'data', handler
  onExit: (handler) ->
    @emitter.on 'exit', handler
  onKill: (handler) ->
    @emitter.on 'kill', handler

  run: (command) ->
    new Promise (resolve, reject) =>
      @kill()
      @emitter.emit('command', command)

      result =
        output: ''
        exited: false
        signal: null

      @spawnProcess(command)

      @subscriptions.add @onData (data) =>
        result.output += data
      @subscriptions.add @onExit =>
        result.exited = true
        resolve(result)
      @subscriptions.add @onKill (signal) =>
        result.signal = signal
        resolve(result)

  kill: (signal) ->
    signal ||= 'SIGTERM'

    if @process?
      @emitter.emit('kill', signal)
      @process.kill(signal)
      @process = null

      @subscriptions.dispose()
      @subscriptions.clear()
