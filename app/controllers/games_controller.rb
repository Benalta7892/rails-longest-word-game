# games_controller.rb
require 'open-uri'
require 'json'

# Controle du jeu
class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').to_a.sample(10).join(' ')
  end

  def score
    @answer = params[:games]
    @letters = params[:letters]
    @message = message

    result_points
  end

  private

  def letter_in_grid
    @answer.upcase.chars.all? { |letter| @letters.include?(letter) }
  end

  def word_valid
    url = "https://wagon-dictionary.herokuapp.com/#{params[:games]}"
    word = JSON.parse(URI.parse(url).read)
    word['found']
  end

  def message
    if !letter_in_grid
      "Sorry but #{@answer} can't be built out of #{@letters}"
    elsif !word_valid
      "Sorry but #{@answer} does not seem to be a valid English word..."
    else
      "Congratulations! #{@answer} is a valid English word!"
    end
  end

  def result_points
    @result = letter_in_grid && word_valid ? @answer.length : 0
  end
end
