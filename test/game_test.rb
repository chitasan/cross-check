require "./test/test_helper"

class GameTest < Minitest::Test

  def setup
    @game = Game.new
  end

  def test_game_exists
    assert_instance_of Game, @game
  end
end
