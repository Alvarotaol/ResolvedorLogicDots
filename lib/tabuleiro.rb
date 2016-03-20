require_relative 'desenhar'
include Desenhar

class Tabuleiro
  attr_reader :matriz
  attr_accessor :tcasa, :pontos
  
  def initialize(x,y, t=4)
    @x = x
    @y = y
    @t = t
    @matriz = [t]*t
    @matriz.map! { |m| [0]*m }
    @tcasa = 20
    
    @mapa = {indef: 0, vazio: 1, pont: 2, cima: 3,
            dire: 4, baixo: 5, esq: 6, vert: 7, hori: 8, decre: -1, incre: 1}
  end
  
  def tamanho= t
    @t = t
    @matriz = [t]*t
    @matriz.map! { |m| [0]*m }
  end
  
  def clicar x, y, d
    dx = x - @x
    dy = y - @y
    return false if(dx < 0 or dy < 0 or dx >= @tcasa*@t or dy >= @tcasa*@t)
    dx /= @tcasa
    dy /= @tcasa
    if(d == :decre or d == :incre)
      @matriz[dx][dy] += @mapa[d]
      @matriz[dx][dy] %= 9 #TODO constante
    else
      @matriz[dx][dy] = @mapa[d]
    end
    true
  end
  
  def draw
    #desenhar tabuleiro
    Desenhar::cor= 0xff0000ff
    0.upto(@t) do |i|
      Desenhar::linha @x + i*@tcasa, @y, @x + @tcasa*i, @y + @t*@tcasa
      Desenhar::linha @x, @y + i*@tcasa, @x + @t*@tcasa, @y + @tcasa*i
    end
    
    #desenhar pontos
    @matriz.each_index do |i|
      @matriz[i].each_index do |j|
        @pontos[@matriz[i][j]-1].draw(@x+i*@tcasa, @y+j*@tcasa,1) if @matriz[i][j] > 0
      end
    end
  end
end