players = []

player_1 = {
  name: "David",
  user_id: 1
}

players << player_1

player_2 = {
  name: "Goliath",
  user_id: 2
}

players << player_2

player_3 = {
  name: "Somebody else",
  user_id: 3
}

players << player_3

players.each do |player|
  Player.find_by_name(player[:name]) || Player.create!(player)
end
