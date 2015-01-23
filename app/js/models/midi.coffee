class Seq25.Midi
  constructor: (@output)->

  play: (pitch, velocity, channel, start=0, duration)->
    now = performance.now()
    noteOnTime = now + (start * 1e3)
    @sendOnAt(pitch, velocity, channel - 1, noteOnTime)
    noteOffTime = now + ((start + duration) * 1e3)
    @sendOffAt(pitch, channel - 1, noteOffTime) if duration

  stop: (pitch, channel)->
    @sendOffAt(pitch, channel - 1, 0)

  stopAllNotes: (channel)->
    @sendAllNotesOff(channel - 1, 0)

  sendOnAt: (pitch, velocity, channel, timeFromNow)->
    ON = 0x90 ^ channel
    @output.send [ON, pitch, Math.floor(velocity * 127)], timeFromNow

  sendOffAt: (pitch, channel, timeFromNow)->
    OFF = 0x80 ^ channel
    @output.send [OFF, pitch, 0x7f], timeFromNow

  sendAllNotesOff: (channel, timeFromNow) ->
    AUX = 0xB0 ^ channel
    @output.send [AUX, 123, 0], timeFromNow

connectionPromise = null
Seq25.Midi.connect = ->
  connectionPromise ||= new Em.RSVP.Promise (resolve, reject) ->
    navigator.requestMIDIAccess()
    .then (access)->
      tempOutput = null
      iterator = access.outputs.values()
      midiOutput = iterator.next()
      while(midiOutput.done == false)
        if midiOutput.value.name.match(/router/)
          console.log(midiOutput.value.name)
          tempOutput = midiOutput
          break
        else
          tempOutput = midiOutput
        midiOutput = iterator.next()

      if tempOutput
        debugger
        resolve(new Seq25.Midi(tempOutput.value))
      else
        console.log 'connected, but no outputs'
        reject()
    .catch ->
      console.log "midi connection failure"
      reject()
