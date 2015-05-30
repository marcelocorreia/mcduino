{CompositeDisposable} = require 'atom'
CommandRunner         = require '../lib/command-runner'

describe "CommandRunner", ->
  beforeEach ->
    @runner = new CommandRunner()

  it "runs commands", ->
    command = 'echo "Hello, wrold!"'
    waitsForPromise =>
      @runner.run(command).then (result) ->
        expect(result.output).toEqual("Hello, wrold!\n")
        expect(result.status).toEqual(0)

  it "returns all command results", ->
    command = 'echo "out"; echo "more out"; >&2 echo "error"; false'
    waitsForPromise =>
      @runner.run(command).then (result) ->
        expect(result.stdout).toEqual("out\nmore out\n")
        expect(result.stderr).toEqual("error\n")
        expect(result.output).toEqual("out\nmore out\nerror\n")
        expect(result.status).not.toEqual(0)

  it "returns raw escape codes", ->
    command = 'echo -e "\\x1B[31mHello\\033[0m, wrold!"'
    waitsForPromise =>
      @runner.run(command).then (result) ->
        expect(result.output).toEqual("\x1B[31mHello\x1B[0m, wrold!\n")

  it "can kill a long-running command", ->
    command = 'while true; do echo -n; done'

    promise = @runner.run(command)
    @runner.kill('SIGKILL')

    waitsForPromise ->
      promise.then (result) ->
        expect(result.signal).toEqual('SIGKILL')

  it "kills one command before starting another", ->
    firstCommand = 'while true; do echo -n; done'
    secondCommand = 'echo "foo"'

    firstPromise = @runner.run(firstCommand)
    secondPromise = @runner.run(secondCommand)

    waitsForPromise ->
      firstPromise.then (result) ->
        expect(result.signal).toBeTruthy()

    waitsForPromise ->
      secondPromise.then (result) ->
        expect(result.output).toEqual("foo\n")

  describe "events", ->
    it "emits an event when running a command", ->
      command = 'echo "foo"'
      handler = jasmine.createSpy('onCommand')

      @runner.onCommand(handler)

      waitsForPromise =>
        @runner.run(command).then ->
          expect(handler).toHaveBeenCalledWith('echo "foo"')
          expect(handler.calls.length).toEqual(1)

    it "emits events on output", ->
      command = 'echo "foo"; >&2 echo "bar"'

      stdoutHandler = jasmine.createSpy('onStdout')
      stderrHandler = jasmine.createSpy('onStderr')

      @runner.onStdout(stdoutHandler)
      @runner.onStderr(stderrHandler)

      waitsForPromise =>
        @runner.run(command).then ->
          expect(stdoutHandler).toHaveBeenCalledWith("foo\n")
          expect(stdoutHandler.calls.length).toEqual(1)

          expect(stderrHandler).toHaveBeenCalledWith("bar\n")
          expect(stderrHandler.calls.length).toEqual(1)

    it "emits an event on exit", ->
      command = 'echo "Hello, wrold!"'
      handler = jasmine.createSpy('onExit')

      @runner.onExit(handler)

      waitsForPromise =>
        @runner.run(command).then ->
          expect(handler).toHaveBeenCalledWith(0)
          expect(handler.calls.length).toEqual(1)

    it "emits an event on kill", ->
      command = 'while true; do echo -n; done'
      handler = jasmine.createSpy('onKill')

      @runner.onKill(handler)

      promise = @runner.run(command)
      @runner.kill('SIGKILL')

      waitsForPromise ->
        promise.then ->
          expect(handler).toHaveBeenCalledWith('SIGKILL')
          expect(handler.calls.length).toEqual(1)
