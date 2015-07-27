{ContentDisposable} = require 'atom'

fs = require('fs');

module.exports =
class Utils
  @stringIsBlank: (str) ->
    !str or /^\s*$/.test str

  @getProperty: (property) ->
    return atom.config.get(property)

  @getArduinoSDK: ->
    return  Utils.getProperty('mcduino.arduinoPath') + '/Contents/Resources/Java/'

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
    content = fs.readFileSync @getArduinoSDK() + '/hardware/arduino/boards.txt', 'utf8'
    boardsArr = content.split('\n')
    boards = []
    for bLine in boardsArr
      if bLine.indexOf "#" , 0 isnt 0
        blArr = bLine.split('.')
        boards.push blArr[0]

    return @removeDuplicatesNoEmptyValues(boards)

  @sleep = (ms) ->
    start = new Date().getTime()
    continue while new Date().getTime() - start < ms
