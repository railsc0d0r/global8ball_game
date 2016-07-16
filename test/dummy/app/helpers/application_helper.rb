module ApplicationHelper
  def current_viewer_select
    players = Player.all

    html = "<select id='current_viewer'>".html_safe

    players.each do | player |
      unless player == players.first
        html.safe_concat "  <option value='{\"user_id\": #{player.id}, \"name\": \"#{player.name}\"}'>#{player.name}</option>"
      else
        html.safe_concat "  <option value='{\"user_id\": #{player.id}, \"name\": \"#{player.name}\"}' selected='selected'>#{player.name}</option>"
      end
    end

    html.safe_concat "</select>"

    html
  end

  def current_stage_select
    stages = [
      'PlayForBegin',
      'PlayForVictory',
      'ShowResult'
    ]

    html = "<select id='current_stage'>".html_safe

    stages.each do |stage|
      unless stage == stages.first
        html.safe_concat " <option value='#{stage}'>#{stage}</option>"
      else
        html.safe_concat " <option value='#{stage}' selected='selected'>#{stage}</option>"
      end
    end

    html.safe_concat "</select>"

    html
  end
end
