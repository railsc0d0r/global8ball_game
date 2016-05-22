class GamesController < ApplicationController
  # GET /games
  def show
    render 'show', layout: false
  end
end
