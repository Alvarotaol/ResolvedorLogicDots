require_relative 'desenhar'
include Desenhar

class Tabuleiro
  attr_reader :matriz
  attr_accessor :tcasa
  
  def initialize(x,y, t=4)
    @x = x
    @y = y
    @t = t
    @matriz = [[0]*t]*t
    @tcasa = 20
  end
  
  def tamanho= t
    @t = t
    @matriz = [[0]*t]*t
  end
  
  def draw
    #desenhar tabuleiro
    Desenhar::cor= 0xff0000ff
    0.upto(@t) do |i|
      Desenhar::linha @x + i*@tcasa, @y, @x + @tcasa*i, @y + @t*@tcasa
      Desenhar::linha @x, @y + i*@tcasa, @x + @t*@tcasa, @y + @tcasa*i
    end
  end
end