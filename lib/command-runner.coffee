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
        @emitter.emit('stdout', data)
      stderr: (data) =>
        @emitter.emit('stderr', data)
      exit: (code) =>
        @emitter.emit('exit', code)

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
  onStdout: (handler) ->
    @emitter.on 'stdout', handler
  onStderr: (handler) ->
    @emitter.on 'stderr', handler
  onExit: (handler) ->
    @emitter.on 'exit', handler
  onKill: (handler) ->
    @emitter.on 'kill', handler

  run: (command) ->
    new Promise (resolve, reject) =>
      @kill()
      @emitter.emit('command', command)

      result =
        stdout: ''
        stderr: ''
        output: ''
        status: null
        signal: null

      @spawnProcess(command)

      @subscriptions.add @onStdout (data) =>
        result.stdout += data
        result.output += data
      @subscriptions.add @onStderr (data) =>
        result.stderr += data
        result.output += data
      @subscriptions.add @onExit (code) =>
        result.status = code
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
