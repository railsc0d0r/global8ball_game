module ApplicationHelper
  def current_viewer_select
    players = Player.all

    html = "<select id='current_viewer'>".html_safe

    players.each do | player |
      unless player == players.first
        html.safe_concat "  <option value='#{player.id}, #{player.name}'>#{player.name}</option>"
      else
        html.safe_concat "  <option value='#{player.id}, #{player.name}' selected>#{player.name}</option>"
      end
    end

    html.safe_concat "</select>"

    html
  end
end
