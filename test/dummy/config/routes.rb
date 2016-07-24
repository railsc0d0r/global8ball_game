Rails.application.routes.draw do
  # use these routes only to simplify development of the game
  get 'game' => 'games#show', as: :game
  get 'reset' => 'games#reset_results', as: :reset

  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'

  root 'games#show'
end
