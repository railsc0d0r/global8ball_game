#= require game/prolog

# Represents an account, corresponding to a real person who can play and/or
# watch games and interact with the site.
class global8ball.Account
  constructor: (@id, @name) ->

  equals: (otherAccount) ->
    otherAccount.id is @id
