TICKS_PER_BEAT = 96
Seq25.Note = DS.Model.extend
  pitchNumber: DS.attr 'number'
  beat:        DS.attr 'number'
  tick:        DS.attr 'number'
  part:        DS.belongsTo 'part'
  duration:    DS.attr 'number', defaultValue: TICKS_PER_BEAT
  secondsPerBeat: Em.computed.alias 'part.secondsPerBeat'

  pitch: Em.computed 'pitchNumber', ->
    Seq25.Pitch.all.findBy 'number', @get('pitchNumber')

  setBeatAndTick: (->
    ticks = Math.round @get('beat_count') * TICKS_PER_BEAT * @get('position')
    @set 'absoluteTicks', ticks
    @snap(@get('quant'), Math.floor)
  ).observes('beat_count', 'position')

  absolueSeconds: (->
    @ticksToTime @get 'absoluteTicks'
  ).property('absoluteTicks', 'secondsPerBeat')

  durationSeconds: Em.computed 'duration', 'secondsPerBeat', ->
    @ticksToTime @get 'duration'

  absoluteTicks: ((_, ticks)->
    if ticks == undefined
      @get('beat') * TICKS_PER_BEAT + @get('tick')
    else
      @setProperties
        beat: Math.floor(ticks / TICKS_PER_BEAT)
        tick: ticks % TICKS_PER_BEAT
      ticks
  ).property('beat', 'tick')

  isPitch: (pitch)->
    @get('pitchNumber') == pitch.number

  ticksToTime: (ticks)->
    (ticks / TICKS_PER_BEAT) * @get('secondsPerBeat')

  snap: (quant, round)->
    return unless quant > 0
    ticksPerGrid = (1 / quant) * TICKS_PER_BEAT
    absoluteTicks = @get('absoluteTicks')
    snappedTicks = round(absoluteTicks / ticksPerGrid) * ticksPerGrid
    if snappedTicks != absoluteTicks
      @set('absoluteTicks', snappedTicks)
      true

  nudge: (quant, round, direction)->
    unless @snap(quant, round)
      ticksPerGrid = (1 / (quant || TICKS_PER_BEAT)) * TICKS_PER_BEAT
      newTicks = @get('absoluteTicks') + (ticksPerGrid * direction)
      if newTicks >= 0
        @set('absoluteTicks', newTicks)

  nudgeLeft: (quant)->
    @nudge(quant, Math.floor, -1)

  nudgeRight: (quant)->
    @nudge(quant, Math.ceil, 1)

  moveUp: (num) ->
    @incrementProperty('pitchNumber', num)

  moveDown: (num) ->
    @incrementProperty('pitchNumber', -1 * num)

  changeDuration: (editResolution) ->
    if @get('duration') + editResolution > 0
      @incrementProperty('duration', editResolution)

Seq25.Note.TICKS_PER_BEAT = TICKS_PER_BEAT
