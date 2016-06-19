#= require game/config/prolog

class global8ball.config.CurrentViewer
  constructor: (data) ->
    @userId = data.user_id
    @name = data.name
