{ContentDisposable} = require 'atom'

fs = require('fs');

module.exports =
class Utils
  @stringIsBlank: (str) ->
    !str or /^\s*$/.test str

  @getProperty: (property) ->
    return atom.config.get(property)

  @checkForArduino:(path)->
    if process.platform is 'darwin'
      boardsFile = Utils.getProperty('mcduino.arduinoPath') + '/Contents/Resources/Java/hardware/arduino/boards.txt'
    else
      boardsFile = Utils.getProperty('mcduino.arduinoPath') + '/hardware/arduino/boards.txt'

    if not which boardsFile
      atom.notifications.addError('Error finding a valid Arduino installation at ' + Utils.getProperty('mcduino.arduinoPath') + '<br>Please check your Arduino installation path and version.<br>Support to Arduino 1.5+ still in the roadmap')

  @getArduinoSDK: ->
    if process.platform is 'darwin'
      if Utils.getProperty('mcduino.arduinoPath') is 'Auto' or Utils.stringIsBlank(Utils.getProperty('mcduino.arduinoPath'))
        defaultPath = '/Applications/Arduino.app'
        atom.notifications.addWarning("Arduino path set to /Applications/Arduino.app<br>You can change it anytime at the preferences panel.")
        atom.config.set('mcduino.arduinoPath', defaultPath)

    Utils.checkForArduino(defaultPath)
    if process.platform is 'darwin'
      return Utils.getProperty('mcduino.arduinoPath') + '/Contents/Resources/Java/'
    else
      return Utils.getProperty('mcduino.arduinoPath')

  @removeDuplicates = (ar) ->
    if ar.length == 0
      return []

    res = {}
    res[ar[key]] = ar[key] for key in [0..ar.length-1]
    value for key, value of res

  @removeDuplicatesNoEmptyValues: (ar) ->
    result = []
    result.push val for val in @removeDuplicates(ar) when val isnt '' or val is not null

    return result

  @getModelsList: ->
    try
      content = fs.readFileSync @getArduinoSDK() + '/hardware/arduino/boards.txt', 'utf8'
      boardsArr = content.split('\n')
      boards = []
      for bLine in boardsArr
        if bLine.indexOf "#" , 0 isnt 0
          blArr = bLine.split('.')
          boards.push blArr[0]

      return @removeDuplicatesNoEmptyValues(boards)
    catch
      atom.notifications.addError("Could not read boards.txt from the path provided<br>Please check your settings");


  @sleep = (ms) ->
    start = new Date().getTime()
    continue while new Date().getTime() - start < ms
