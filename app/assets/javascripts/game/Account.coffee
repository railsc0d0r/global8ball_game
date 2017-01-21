#= require game/prolog

# Represents an account, corresponding to a real person who can play and/or
# watch games and interact with the site.
class global8ball.Account
  # @param {string} id
  # @param {string} name
  constructor: (id, @name) ->
    @id = id + ''

  # Checks wether this account is equal to another account.
  #
  # @param {global8ball.Account} otherAccount
  # @return {boolean}
  equals: (otherAccount) ->
    otherAccount && otherAccount.id is @id
