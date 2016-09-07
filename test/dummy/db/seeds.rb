players = []

player_1 = {
  name: "David",
}

players << player_1

player_2 = {
  name: "Goliath",
}

players << player_2

player_3 = {
  name: "Somebody else",
}

players << player_3

players.each do |player|
  Player.find_by_name(player[:name]) || Player.create!(player)
end
