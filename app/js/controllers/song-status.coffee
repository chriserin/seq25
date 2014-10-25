Seq25.SongStatusController = Ember.Controller.extend
  init: ->
    @set('currentKeys', Seq25.Keystrokes.current)

  needs: 'transport'
  transport: Em.computed.alias('controllers.transport')
  parts: Em.computed.alias('controllers.transport.parts')
  characters: Em.computed.alias('currentKeys.characters')
