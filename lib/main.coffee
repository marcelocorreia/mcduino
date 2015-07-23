{ContentDisposable} = require 'atom'
CommandRunner = require './command-runner'
RunCommandView = require './mcduino-view'
NewProjectView = require './mcduino-new-project-view'
CommandOutputView = require './command-output-view'
RequirementsChecker = require './requirements-checker'

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
      enum: ['uno','atmega328','diecimila','nano328','nana','mega2560','leonardo','esplora','micro','mini328','mini','micro','ethernet','fio','bt328','bt','LilyPadUSB','lilypad328','lilypad','pro5v328','pro5v','pro328','pro','atmega168','atmega8','robotControl','robotMotor']
      description: 'Default: uno'
    serialPort:
      type: 'string'
      default: 'Auto'
    serialBaudRate:
      type: 'string'
      default: '9600'
      enum: ['300','600','1200','1800','2400','3600','4800','7200','9600','14400','19200','28800','38400','57600','115200','230400']
    compilerMake:
      title: 'Compiler Settings: --make MAKE'
      type: 'string'
      default: 'make'
      description: 'Specifies the make tool to use. If a full path is not given, searches in Arduino directories before PATH. Default: make'
    compilerAR:
      type: 'string'
      title: 'Compiler Settings: --ar AR'
      default: 'avr-ar'
      description: 'Specifies the AR tool to use. If a full path is not given, searches in Arduino directories before PATH. Default: avr-ar'
    compilerOBJCOPY:
      type: 'string'
      title: 'Compiler Settings: --objcopy OBJCOPY'
      default: 'avr-objcopy'
      description: 'Specifies the OBJCOPY to use. If a full path is not given, searches in Arduino directories before PATH. Default: avr-objcopy.'
    compilerCC:
      type: 'string'
      title: 'Compiler Settings: --cc COMPILER'
      default: 'avr-gcc'
      description: 'Specifies the compiler used for C files. If a full path is not given, searches in Arduino directories before PATH. Default: avr-gcc'
    compilerCXX:
      type: 'string'
      title: 'Compiler Settings: --cxx COMPILER'
      default: 'avr-g++'
      description: 'Specifies the compiler used for C++ files. If a full path is not given, searches in Arduino directories before PATH. Default: avr-g++'
    compilerFLAGS:
      type: 'string'
      title: 'Compiler Settings: -f FLAGS, --cppflags FLAGS'
      default: '-ffunction-sections -fdata-sections -g -Os -w'
      description: 'Flags that will be passed to the compiler. Note that multiple (space-separated) flags must be surrounded by quotes, e.g. --cppflags="-DC1 -DC2" specifies flags  -ffunction-sections -fdata-sections -g -Os -w'
    compilerVerbose:
      type:'boolean'
      default: false
      title: 'Compiler Settings: -v'
      description: 'Display compilation output in verbose mode'
    compilerCFLAGS:
      type: 'string'
      title: 'Compiler Settings: --cflags FLAGS'
      default: ''
      description: 'Like --cppflags, but the flags specified are only passed to compilations of C source files. Default: ""'
    compilerCXXFLAGS:
      type: 'string'
      title: 'Compiler Settings: --cxxflags FLAGS'
      default: '-ffunction-sections -fdata-sections -g -Os -w'
      description: 'Like --cppflags, but the flags specified are only passed to compilations of C++ source files. Default: "-fno-exceptions"'
    compilerLDFLAGS:
      type: 'string'
      title: 'Compiler Settings: --ldflags FLAGS'
      default: '-Os --gc-sections'
      description: 'Like --cppflags, but the flags specified are only passed during the linking stage. Note these flags should be specified as if "ld" were being invoked                        directly (i.e. the "-Wl," prefix should be omitted). Default: "-Os --gc-sections"'



  activate: (state) ->
    @runner = new CommandRunner()
    @newProjectAgent = new NewProjectView(@runner)
    @commandOutputView = new CommandOutputView(@runner)
    @runCommandView = new RunCommandView(@runner)
    @reqChecker = new RequirementsChecker(@runner)

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
      'mcduino:checkRequirements': => @checkRequirements()

  deactivate: ->
    @runCommandView.destroy()
    @commandOutputView.destroy()

  dispose: ->
    @subscriptions.dispose()

  checkRequirements: ->
    console.log @reqChecker.getHomeDirectory()

  inoRun: (inoCommand, openConsole) ->
    @runner.run(@getProperty('mcduino.inoPath') + ' ' + inoCommand, openConsole)

  inoRunWithOptions: (inoCommand, extraInoOptions, openConsole) ->
    inoOptions = ' ' + @getDefaultInoOptions()

    if(extraInoOptions)
      inoOptions += ' ' + extraInoOptions

    @runner.run(@getProperty('mcduino.inoPath') + ' ' + inoCommand + inoOptions, openConsole)

  inoCheck: ->
    # @runner.run(@getProperty('mcduino.inoPath') + ' --help')
    @inoRun('--help', true)

  inoClean: ->
    @inoRun('clean', true)

  inoBuild: ->
    @inoClean()
    if( @getProperty('mcduino.compilerVerbose'))
      opts = ' -v'
    else
      opts = ''

    @inoRunWithOptions('build', opts, true)

  inoUpload: ->
    @inoBuild()
    @inoRunWithOptions('upload','',true)

  # inoSerial: ->
  #   @inoRun('serial -b ' + @getProperty('mcduino.serialBaudRate') )

  inoListModels: ->
    @inoRun('list-models' , true)

  inoPreproc: ->
    @inoRun('preproc',true)

  inoInit: ->
    @newProjectAgent.show()

  inoConvert: ->
    @runner.run('mkdir src lib; touch lib/.holder; mv *ino src/sketch.ino; mv *cpp src/ *h src', true)

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

    if(@getProperty('mcduino.arduinoPath') isnt 'Auto')
      inoOptions += ' -d ' + @getProperty('mcduino.arduinoPath')

    if(@getProperty('mcduino.serialPort') isnt 'Auto')
      inoOptions += ' -p ' + @getProperty('mcduino.serialPort')

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
      icon: 'terminal'
      callback: 'mcduino:run'
      tooltip: 'MCduino: Run shell command'

    @toolBar.addSpacer()

    # Function with data in callback
    @toolBar.addButton
      icon: 'check',
      callback: 'mcduino:inoBuild'
      tooltip: 'MCduino: Verify/Compile'

    @toolBar.addButton
      icon: 'upload',
      callback: 'mcduino:inoUpload'
      tooltip: 'MCduino: Upload'
      iconset: 'fi'

    @toolBar.addButton
      icon: 'trashcan',
      callback: 'mcduino:inoClean'
      tooltip: 'MCduino: Clean'

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
