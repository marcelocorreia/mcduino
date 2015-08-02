{Editor} = require 'atom'
Utils  = require '../lib/mcduino-utils'


describe "Utils", ->

  it "retrieves atom config", ->
    spyOn(Utils, 'getProperty').andReturn('/Applications/Arduino.app')
    expect(Utils.getProperty('blah')).toEqual('/Applications/Arduino.app')

  it "gets arduino path", ->
    spyOn(Utils, 'getArduinoSDK').andReturn('/Applications/Arduino.app')
    expect(Utils.getArduinoSDK('blah')).toEqual('/Applications/Arduino.app')

  it "retrieves supported boards", ->
    spyOn(Utils, 'getModelsList').andReturn('uno,mega,anyOne')
    expect(Utils.getModelsList()).toEqual('uno,mega,anyOne')

  it "remove duplicates", ->
    expect(Utils.removeDuplicatesNoEmptyValues(['uno','uno','mega',''])).toEqual(['uno','mega'])

  it "checks for empty/null string", ->
    expect(Utils.stringIsBlank('blah')).toEqual(false)
    expect(Utils.stringIsBlank('')).toEqual(true)
    expect(Utils.stringIsBlank()).toEqual(true)
