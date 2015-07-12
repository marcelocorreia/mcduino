{ContentDisposable} = require 'atom'
CommandRunner = require './command-runner'
RunCommandView = require './mcduino-view'
CommandOutputView = require './command-output-view'
# inoFuckingPath = atom.config.get('mcduino.inoPath')

module.exports =
  config:
    shellCommand:
      type: 'string'
      default: '/bin/bash'
    inoPath:
      type: 'string'
      default: '/usr/local/bin/ino'
    verbose:
      type:'boolean'
      default: false
    boardModel:
      type: 'string'
      default: 'uno'
      enum: ['uno','atmega328','diecimila','mega2560','leonardo']
    arduinoPath:
      type: 'string'
      default: '/Applications/Arduino.app'

  activate: (state) ->
    @runner = new CommandRunner()
    @commandOutputView = new CommandOutputView(@runner)
    @runCommandView = new RunCommandView(@runner)

    @subscriptions = atom.commands.add 'atom-workspace',
      'mcduino:run': => @run()
      'mcduino:toggle-panel': => @togglePanel(),
      'mcduino:kill-last-command': => @killLastCommand()
      'mcduino:inoCheck': => @inoCheck()
      'mcduino:inoClean': => @inoClean()
      'mcduino:inoBuild': => @inoBuild()
      'mcduino:inoUpload': => @inoUpload()
      'mcduino:inoSerial': => @inoSerial()
      'mcduino:inoListModels': => @inoListModels()
      'mcduino:inoPreproc': => @inoPreproc()
      'mcduino:inoInit': => @inoInit()
      'mcduino:inoConvert': => @inoConvert()
  deactivate: ->
    @runCommandView.destroy()
    @commandOutputView.destroy()

  dispose: ->
    @subscriptions.dispose()

  inoRun: (inoCommand) ->
    @runner.run(@getProperty('mcduino.inoPath') + ' ' + inoCommand)

  inoCheck: ->
    # @runner.run(@getProperty('mcduino.inoPath') + ' --help')
    @inoRun('--help')

  inoClean: ->
    @inoRun('clean')

  inoBuild: ->
    @inoClean()
    @inoRun('build -v')

  inoUpload: ->
    @inoBuild()
    @inoRun('upload')

  inoSerial: ->
    @inoRun('serial')

  inoListModels: ->
    @inoRun('list-models')

  inoPreproc: ->
    @inoRun('preproc')

  inoInit: ->
    @runCommandView.newProject()

  inoConvert: ->
    @runner.run('mkdir src lib; touch lib/.holder; mv *ino src/sketch.ino; mv *cpp src/ *h src')

  run: ->
    @runCommandView.show()

  togglePanel: ->
    if @commandOutputView.isVisible()
      @commandOutputView.hide()
    else
      @commandOutputView.show()

  killLastCommand: ->
    @runner.kill()

  getProperty: (property) ->
    return atom.config.get(property)

  #tool-bar
  consumeToolBar: (toolBar) ->
    @toolBar = toolBar 'mcduino'

    button = @toolBar.addButton
      icon: 'gear'
      callback: 'application:show-settings'
      tooltip: 'Boards'

    @toolBar.addSpacer()

    # Function with data in callback
    @toolBar.addButton
      icon: 'check',
      callback: 'mcduino:inoBuild'
      tooltip: 'Verify/Compile'

    @toolBar.addButton
      icon: 'upload',
      callback: 'mcduino:inoUpload'
      tooltip: 'Upload'
      iconset: 'fi'

    @toolBar.addButton
      icon: 'trashcan',
      callback: 'mcduino:inoClean'
      tooltip: 'Clean'

    @toolBar.addSpacer()

    @toolBar.addButton
      icon: 'x',
      callback: 'tool-bar:toggle'
      tooltip: 'Close Toolbar'

    @toolBar.addSpacer()

    # # Adding spacer and button at the beginning of the tool bar
    # @toolBar.addSpacer #priority: 10
    # @toolBar.addButton
    #   icon: '.octicon-check'
    #   callback: 'application:about'
    #   # priority: 10
