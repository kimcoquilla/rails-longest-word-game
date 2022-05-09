require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').to_a.shuffle[0..9]
  end

  def score
  @answer = params[:answer]
  @letters = params[:letters]
  url = "https://wagon-dictionary.herokuapp.com/#{@answer}"
  json_string = URI.open(url).read
  result = JSON.parse(json_string)
    if result["found"] && included?(@answer.upcase, @letters)
      @score = "Congratulations! #{@answer.upcase} is a valid English word"
    elsif result["found"]
      @score = "Sorry but #{@answer.upcase} can't be built out of #{@letters}"
    else
      @score = "Sorry but #{@answer.upcase} does not seem to be a valid English word"
    end
  end

  private

  def included?(answer, letters)
    answer.chars.all? {|letter| answer.count(letter) <= letters.count(letter)}
  end
end
