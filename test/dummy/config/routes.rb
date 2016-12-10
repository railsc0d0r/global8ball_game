Rails.application.routes.draw do
  # use these routes only to simplify development of the game
  get 'game' => 'games#show', as: :game
  get 'reset' => 'games#reset', as: :reset

  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)

  root 'games#show'
end
