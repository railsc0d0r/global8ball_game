#= require game/Account

Account = global8ball.Account

describe 'Account', () ->
  it 'equals another account with the same ID', () ->
    anAccount = new Account 'foobar', 'Foo Bar'
    otherAccount = new Account 'foobar', 'Bar Foo'

    expect(anAccount.equals otherAccount).toBeTruthy()
