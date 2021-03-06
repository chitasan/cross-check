module List
  def all_games_for_team(team)
    hash_home_games_by_team[team] + hash_away_games_by_team[team]
  end

  def team_id_swap(input)
    desired_team = @teams.repo.find do |team|
      team.team_id == input
    end
    desired_team.team_name
  end

  def total_points_for_team(team)
    game_teams = hash_game_teams_by_team[team]
    game_teams.inject(0) do |sum, game_team|
      sum + game_team.goals
    end
  end

  def won_games(team)
    won_home = won_home_games(team)
    won_away = won_away_games(team)
    won_home + won_away
  end

  def win_percentage(team)
    game_teams = hash_game_teams_by_team[team]
    won_game_teams = game_teams.find_all do |game_team|
      game_team.won? == true
    end
    (won_game_teams.count.to_f / game_teams.count).round(2)
  end

  def total_scores
    @games.repo.map do |game|
      game.away_goals + game.home_goals
    end
  end

  def teams_score_difference
    @games.repo.map do |game|
      (game.away_goals - game.home_goals)
    end
  end

  def total_games
    @games.repo.map do |game|
      game.game_id
    end.size
  end

  def total_visitor_wins
    teams_score_difference.select do |score_diff|
      score_diff > 0
    end.size
  end

  def total_goals_all_seasons
    total_away_goals = @games.repo.sum do |game|
      game.away_goals
    end
    total_home_goals = @games.repo.sum do |game|
      game.home_goals
    end
    total_away_goals + total_home_goals
  end

  def get_team_info(team_id)
    @teams.repo.find do |team|
      team.team_id == team_id
    end
  end

  def won_home_games(team)
    hash_home_games_by_team[team].find_all do |game|
      game.outcome.include?("home")
    end
  end

  def won_away_games(team)
    hash_away_games_by_team[team].find_all do |game|
      game.outcome.include?("away")
    end
  end

  def games_by_season
    @games.repo.group_by { |game| game.season }
  end
end
