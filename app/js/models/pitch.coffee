NOTE_NAMES = "A A# B C C# D D# E F F# G G#".w()
A0_PITCH = 27.5
MIN_PITCH_NUM = 21
MAX_PITCH_NUM = 108

Seq25.Pitch = Ember.Object.extend
  pitch: Em.computed -> this

  init: ->
    number = @get('number')
    @set 'name', NOTE_NAMES[(number - MIN_PITCH_NUM) % 12] + Math.round((number - 17) / 12)
    @set 'freq', A0_PITCH * Math.pow(2, (number - MIN_PITCH_NUM)/12)
    @set 'isSharp', @get('name').indexOf('#') > 0

.reopenClass
  numberAtScale: (scale)->
    @all[Math.floor(@all.length * scale)].get('number')

  scaleAtPitch: (pitch)->
    @all.indexOf(pitch) / @all.length

  highest: (num)->
    Math.min @all.get('firstObject.number'), num

  lowest: (num)->
    Math.max @all.get('lastObject.number'), num

pitches = for number in [MIN_PITCH_NUM..MAX_PITCH_NUM]
  Seq25.Pitch.create(number: number)
Seq25.Pitch.all = pitches.reverse()
Seq25.Pitch.MIDPOINT = Math.floor((MIN_PITCH_NUM + MAX_PITCH_NUM) / 2)
