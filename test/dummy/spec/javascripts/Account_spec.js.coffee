#= require game/Account

Account = global8ball.Account

describe 'Account', () ->
  it 'equals another account with the same ID', () ->
    anAccount = new Account 'foobar', 'Foo Bar'
    otherAccount = new Account 'foobar', 'Bar Foo'

    expect(anAccount.equals otherAccount).toBeTruthy()

  it 'does not equal another account with a different ID', () ->
    anAccount = new Account 'foobar', 'Foo Bar'
    otherAccount = new Account 'barfoo', 'Bar Foo'

    expect(anAccount.equals otherAccount).toBeFalsy()

  it 'stringifies numeric IDs', ->
    anAccount = new Account 9001, 'Son Goku'
    otherAccount = new Account '9001', 'Son Goku'

    expect(anAccount.equals otherAccount).toBeTruthy()
