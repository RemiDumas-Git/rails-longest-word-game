require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @letters = params[:letters]
    @answer = params[:answer]
    if word_exist?(@answer) == false
      @solution = '1'
    elsif grid_letter?(@answer, @letters) == false
      @solution = '2'
    else
      @solution = '3'
    end
  end

  def word_exist?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    serialized_attempt = URI.open(url).read
    result = JSON.parse(serialized_attempt)
    result["found"]
  end

  def grid_letter?(word, grid)
    word_array = word.downcase.chars
    grid_array = grid.split.map! do |i|
      i.downcase
    end
    letter_left = word_array.reject! do |char|
      grid_array.include?(char)
      grid_array.delete_at(grid_array.index(char)) if grid_array.include?(char)
    end
    letter_left == []
  end
end
