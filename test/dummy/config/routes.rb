Rails.application.routes.draw do
  # use this route only to simplify development of the game
  get 'game' => 'games#show', as: :game

  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'

  root 'games#show'
end
