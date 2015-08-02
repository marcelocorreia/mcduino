{ContentDisposable} = require 'atom'
CommandRunner = require './command-runner'
RunCommandView = require './mcduino-view'
NewProjectView = require './mcduino-new-project-view'
CommandOutputView = require './command-output-view'
BoardSelectorView = require './mcduino-board-selector-view'
Utils = require './mcduino-utils'
fs = require('fs');
shell = require 'shelljs/global'

module.exports =
  config:
    arduinoPath:
      type: 'string'
      default: 'Auto'
    inoPath:
      type: 'string'
      default: '/usr/local/bin/ino'
    shellCommand:
      type: 'string'
      default: '/bin/bash'
    boardModel:
      type: 'string'
      default: 'uno'
      enum: Utils.getModelsList()
      description: 'Default: uno'
    serialPort:
      type: 'string'
      default: 'Auto'
    compilerExtraOptions:
      title: 'Compiler extra options & Flags'
      type: 'string'
      default: 'Auto'
      description: 'Please refer to README section for more information on Options & Flags'

  activate: (state) ->
    @runner = new CommandRunner()
    @newProjectAgent = new NewProjectView(@runner)
    @commandOutputView = new CommandOutputView(@runner)
    @runCommandView = new RunCommandView(@runner)

    @subscriptions = atom.commands.add 'atom-workspace',
      'mcduino:run': => @run()
      'mcduino:toggle-panel': => @togglePanel()
      'mcduino:kill-last-command': => @killLastCommand()
      'mcduino:ino-check': => @inoCheck()
      'mcduino:ino-clean': => @inoClean()
      'mcduino:ino-build': => @inoBuild()
      'mcduino:ino-upload': => @inoUpload()
      'mcduino:ino-list-models': => @inoListModels()
      'mcduino:ino-preproc': => @inoPreproc()
      'mcduino:ino-new-project': => @inoNewProject()
      'mcduino:ino-convert': => @inoConvert()
      'mcduino:boards-txt': => @boardsTXT()
      'mcduino:board-select': => @boardSelect()
      # 'mcduino:dev-test': => @devTest()

    @arduinoSDK = Utils.getArduinoSDK()

  deactivate: ->
    @runCommandView.destroy()
    @commandOutputView.destroy()
    @reqView.destroy()

  devTest: (test)->
    # atom.workspace.open(Utils.getArduinoSDK() + '/examples/')

  boardsTXT: ->
    try
      boardsFile = Utils.getArduinoSDK()+'/hardware/arduino/boards.txt'
      atom.workspace.open(boardsFile)
    catch
      atom.notifications.addError('Error finding opening ' + Utils.getProperty('mcduino.arduinoPath') + '<br>Please check your Arduino installation path and version.')

  boardSelect: (test)->
    @boardSelectorView = new BoardSelectorView()
    @boardSelectorView.show()

  dispose: ->
    @subscriptions.dispose()

  checkRequirements: ->
    @reqChecker.checkItAll()

  inoRun: (inoCommand) ->
    @runner.run(Utils.getProperty('mcduino.inoPath') + ' ' + inoCommand)

  inoRunWithOptions: (inoCommand, extraInoOptions, @upload) ->
    inoOptions = ' ' + @getDefaultInoOptions()

    if(extraInoOptions)
      inoOptions += ' ' + extraInoOptions

    cmd = ''
    cmd += Utils.getProperty('mcduino.inoPath') + ' clean ;'
    cmd += Utils.getProperty('mcduino.inoPath') + ' ' + inoCommand + inoOptions + ' ; '
    cmd += Utils.getProperty('mcduino.inoPath') + ' upload ' + @getDefaultInoOptions() if upload

    @runner.run(cmd)

  inoCheck: ->
    @inoRun('--help')

  inoClean: ->
    @inoRun('clean')

  inoBuild: (@upload)->
    if(Utils.getProperty('mcduino.compilerVerbose'))
      opts = ' -v'
    else
      opts = ''

    opts += Utils.getProperty('mcduino.compilerExtraOptions') if Utils.getProperty('mcduino.compilerExtraOptions') isnt 'Auto'

    if upload
      @inoRunWithOptions('build', opts, 'upload')
    else
      @inoRunWithOptions('build', opts)

  inoUpload: ->
    @inoBuild('upload')

  inoListModels: ->
    @inoRun('list-models')

  inoPreproc: ->
    @inoRun('preproc',true)

  inoConvert: ->
    @runner.run('mkdir src lib; touch lib/.holder; mv *ino src/sketch.ino; mv *cpp src/ *h src')

  inoNewProject: ->
    @newProjectAgent.show()

  sleep: (ms) ->
    start = new Date().getTime()
    continue while new Date().getTime() - start < ms

  run: ->
    @runCommandView.show()

  togglePanel: ->
    if @commandOutputView.isVisible()
      @commandOutputView.hide()
    else
      @commandOutputView.show()

  killLastCommand: ->
    @runner.kill()

  getDefaultInoOptions: ->
    inoOptions = ''

    if(Utils.getProperty('mcduino.boardModel'))
      inoOptions += ' -m ' + Utils.getProperty('mcduino.boardModel')

    if(Utils.getProperty('mcduino.arduinoPath') or Utils.getProperty('mcduino.arduinoPath') isnt 'Auto')
      inoOptions += ' -d ' + Utils.getArduinoSDK()

    if(Utils.getProperty('mcduino.serialPort') isnt 'Auto')
      inoOptions += ' -p ' + Utils.getProperty('mcduino.serialPort')

    return inoOptions

  #tool-bar
  consumeToolBar: (toolBar) ->
    @toolBar = toolBar 'mcduino'

    button = @toolBar.addButton
      icon: 'gear'
      callback: 'application:show-settings'
      tooltip: 'MCduino: Settings'

    @toolBar.addButton
      icon: 'floppy-o'
      callback: 'window:save-all'
      tooltip: 'MCduino: Save all'
      iconset: 'fa'

    @toolBar.addButton
      icon: 'sync'
      callback: 'window:reload'
      tooltip: 'MCduino: Reload IDE'

    @toolBar.addButton
      icon: 'terminal'
      callback: 'mcduino:run'
      tooltip: 'MCduino: Run shell command'

    @toolBar.addSpacer()

    # Function with data in callback
    @toolBar.addButton
      icon: 'check',
      callback: 'mcduino:ino-build'
      tooltip: 'MCduino: Verify/Compile'

    @toolBar.addButton
      icon: 'upload',
      callback: 'mcduino:ino-upload'
      tooltip: 'MCduino: Upload'
      iconset: 'fi'

    @toolBar.addButton
      icon: 'trashcan',
      callback: 'mcduino:ino-clean'
      tooltip: 'MCduino: Clean'

    @toolBar.addSpacer()

    @toolBar.addButton
      icon: 'x',
      callback: 'tool-bar:toggle'
      tooltip: 'Close Toolbar'

    @toolBar.addSpacer()
