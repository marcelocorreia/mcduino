{ContentDisposable} = require 'atom'
CommandRunner = require './command-runner'
RunCommandView = require './mcduino-view'
CommandOutputView = require './command-output-view'

module.exports =
  config:
    shellCommand:
      type: 'string'
      default: '/bin/bash'

  activate: (state) ->
    @runner = new CommandRunner()

    @commandOutputView = new CommandOutputView(@runner)
    @runCommandView = new RunCommandView(@runner)

    @subscriptions = atom.commands.add 'atom-workspace',
      'run-command:run': => @run()
      'run-command:toggle-panel': => @togglePanel(),
      'run-command:kill-last-command': => @killLastCommand()
      'run-command:inoCheck': => @inoCheck()
      'run-command:inoClean': => @inoClean()
      'run-command:inoBuild': => @inoBuild()
      'run-command:inoUpload': => @inoUpload()
      'run-command:inoSerial': => @inoSerial()
      'run-command:inoListModels': => @inoListModels()
      'run-command:inoPreproc': => @inoPreproc()
      'run-command:inoInit': => @inoInit()

  deactivate: ->
    @runCommandView.destroy()
    @commandOutputView.destroy()

  dispose: ->
    @subscriptions.dispose()

  inoCheck: ->
    @runner.run('/usr/local/bin/ino --help')

  inoClean: ->
    @runner.run('/usr/local/bin/ino clean')

  inoBuild: ->
    @runner.run('/usr/local/bin/ino build')

  inoUpload: ->
    @runner.run('/usr/local/bin/ino upload')

  inoSerial: ->
    @runner.run('/usr/local/bin/ino serial')

  inoListModels: ->
    @runner.run('/usr/local/bin/ino list-models')

  inoPreproc: ->
    @runner.run('/usr/local/bin/ino preproc')

  inoInit: ->
    @runCommandView.newProject()

  run: ->
    @runCommandView.show()

  togglePanel: ->
    if @commandOutputView.isVisible()
      @commandOutputView.hide()
    else
      @commandOutputView.show()

  killLastCommand: ->
    @runner.kill()
