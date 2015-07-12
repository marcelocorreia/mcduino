{ContentDisposable} = require 'atom'
CommandRunner = require './command-runner'
RunCommandView = require './mcduino-view'
NewProjectView = require './mcduino-new-project-view'
CommandOutputView = require './command-output-view'


module.exports =
  config:
    arduinoPath:
      type: 'string'
      default: 'auto'
    inoPath:
      type: 'string'
      default: '/usr/local/bin/ino'
    shellCommand:
      type: 'string'
      default: '/bin/bash'
    verbose:
      type:'boolean'
      default: false
    boardModel:
      type: 'string'
      default: 'uno'
      enum: ['uno','atmega328','diecimila','mega2560','leonardo']
    serialBaudRate:
      type: 'string'
      default: '9600'
      enum: ['300','600','1200','1800','2400','3600','4800','7200','9600','14400','19200','28800','38400','57600','115200','230400']


  activate: (state) ->
    @runner = new CommandRunner()
    @newProjectAgent = new NewProjectView(@runner)
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
      # 'mcduino:inoSerial': => @inoSerial()
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

  inoRunWithOptions: (inoCommand, extraInoOptions) ->
    inoOptions = ' ' + @getDefaultInoOptions()

    if(extraInoOptions)
      inoOptions += ' ' + extraInoOptions

    @runner.run(@getProperty('mcduino.inoPath') + ' ' + inoCommand + inoOptions)

  inoCheck: ->
    # @runner.run(@getProperty('mcduino.inoPath') + ' --help')
    @inoRun('--help')

  inoClean: ->
    @inoRun('clean')

  inoBuild: ->
    @inoClean()
    if( @getProperty('mcduino.verbose'))
      opts = ' -v'
    else
      opts = ''

    @inoRunWithOptions('build', opts)

  inoUpload: ->
    @inoBuild()
    @inoRunWithOptions('upload','')

  # inoSerial: ->
  #   @inoRun('serial -b ' + @getProperty('mcduino.serialBaudRate') )

  inoListModels: ->
    @inoRun('list-models')

  inoPreproc: ->
    @inoRun('preproc')

  inoInit: ->
    # @newProjectAgent.show()
    atom.open('file:///tmp')

  inoConvert: ->
    @runner.run('mkdir src lib; touch lib/.holder; mv *ino src/sketch.ino; mv *cpp src/ *h src')

  inoNewProject: ->
    console.log 'hey'

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

  getProperty: (property) ->
    return atom.config.get(property)

  getDefaultInoOptions: ->
    inoOptions = ''

    if(@getProperty('mcduino.boardModel'))
      inoOptions += ' -m ' + @getProperty('mcduino.boardModel')

    if(@getProperty('mcduino.arduinoPath') isnt 'auto')
      inoOptions += ' -d ' + @getProperty('mcduino.arduinoPath')

    return inoOptions

  #tool-bar
  consumeToolBar: (toolBar) ->
    @toolBar = toolBar 'mcduino'

    button = @toolBar.addButton
      icon: 'gear'
      callback: 'application:show-settings'
      tooltip: 'Boards'

    @toolBar.addButton
      icon: 'floppy-o'
      callback: 'window:save-all'
      tooltip: 'Save all'
      iconset: 'fa'

    @toolBar.addButton
      icon: 'terminal'
      callback: 'mcduino:run'
      tooltip: 'Run shell command'

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
