Seq25.ApplicationRoute = Ember.Route.extend
  setupController: ->
    pitches = for number in [21..95] #[21..108]
      Seq25.Pitch.create(number: number)
    Seq25.Pitch.all = pitches.reverse()
    Seq25.Keystrokes.current = Seq25.CurrentKeystrokes.create
      numbers: ""
      parts: ""

  actions:
    openHelp: ->
      this.render 'help',
        outlet: 'help'
        into: 'application'
