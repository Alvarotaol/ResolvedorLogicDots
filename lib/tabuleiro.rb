require_relative 'desenhar'
include Desenhar

       
class Matriz
  def initialize t
    @t = t
    @m = [t]*t
    @m.map! { |m| [0]*m }
  end
  
  def tamanho= t
    @t = t
    @m = [t]*t
    @m.map! { |m| [0]*m }
  end
  
  def el x, y, e
    unless x < 0 or y < 0 or x >= @t or y >= @t
      @m[x][y] = e
      e
    else
      nil
    end
  end
  
  def arel ar, v
    ar.each do |i|
      el i[0], i[1], v
    end
  end
  
  def ml x, y, e
    unless x < 0 or y < 0 or x >= @t or y >= @t
      @m[x][y] += e
      @m[x][y] %= 9
    end
    @m[x][y]
  end
  
  def each! 
    0.upto(@t-1) do |i|
      0.upto(@t-1) do |j|
        yield(i,j,@m[i][j])
      end
    end
  end
end
class Tabuleiro
  attr_reader :matriz
  attr_accessor :tcasa, :pontos
  
  def initialize(x,y, t=5)
    @mapa = {indef: 0, vazio: 1, pont: 2, cima: 3,
            dire: 4, baixo: 5, esq: 6, vert: 7, hori: 8, decre: -1, incre: 1}
   
    @x = x
    @y = y
    @t = t
    @tcasa = 20
    @matriz = Matriz.new t
    
  end
  
  def tamanho= t
    @t = t
    @matriz.tamanho = t
  end
  
  def clicar x, y, d
    dx = x - @x
    dy = y - @y
    return false if(dx < 0 or dy < 0 or dx >= @tcasa*@t or dy >= @tcasa*@t)
    dx /= @tcasa
    dy /= @tcasa
    if(d == :decre or d == :incre)
      @matriz.ml dy, dx, @mapa[d]
    else
      @matriz.el dy, dx, @mapa[d]
    end
    true
  end
  
  def preencher
    @matriz.each! do |i,j,p|
        if p == @mapa[:pont]
          ar = [[i-1, j-1], [i-1, j], [i-1, j+1],
                [i, j-1]  ,           [i, j+1],
                [i+1, j-1], [i+1, j], [i+1, j+1]]
        elsif p == @mapa[:cima]
          ar = [[i-1, j-1],           [i-1, j+1],
                [i, j-1]  ,           [i, j+1],
                [i+1, j-1], [i+1, j], [i+1, j+1]]
        elsif p == @mapa[:dire]
          ar = [[i-1, j-1], [i-1, j], [i-1, j+1],
                [i, j-1]  ,
                [i+1, j-1], [i+1, j], [i+1, j+1]]
        elsif p == @mapa[:baixo]
          ar = [[i-1, j-1], [i-1, j], [i-1, j+1],
                [i, j-1]  ,           [i, j+1],
                [i+1, j-1],           [i+1, j+1]]
        elsif p == @mapa[:esq]
          ar = [[i-1, j-1], [i-1, j], [i-1, j+1],
                                      [i, j+1],
                [i+1, j-1], [i+1, j], [i+1, j+1]]
        elsif p == @mapa[:vert]
          ar = [[i-1, j-1], [i-1, j+1],
                [i, j-1]  , [i, j+1],
                [i+1, j-1], [i+1, j+1]]
        elsif p == @mapa[:hori]
          ar = [[i-1, j-1], [i-1, j], [i-1, j+1],
                [i+1, j-1], [i+1, j], [i+1, j+1]]
        end
        @matriz.arel ar, @mapa[:vazio] unless ar == nil
      end
  end
  
  def converter
    m=[]
    preencher
    @matriz.each! do |i, j, p|
      if m[i]==nil
        m[i] = []
      end
      m[i][j] = p
    end
    p m
    m.each_index do |i|
      m[i].each_index do |j|
        if m[i][j] == @mapa[:cima] or m[i][j] == @mapa[:vert]
          m[i-1][j] = :pont
        end
        if m[i][j] == @mapa[:dire] or m[i][j] == @mapa[:hori]
          m[i][j+1] = :pont
        end
        if m[i][j] == @mapa[:baixo] or m[i][j] == @mapa[:vert]
          m[i+1][j] = :pont
        end
        if m[i][j] == @mapa[:esq] or m[i][j] == @mapa[:hori]
          m[i][j-1] = :pont
        end
        if m[i][j] == @mapa[:indef]
          m[i][j] = :indef
        elsif m[i][j] == @mapa[:vazio]
          m[i][j] = :vazio
        else
          m[i][j] = :pont
        end
        
      end
    end
    m
  end
  
  def draw
    #desenhar tabuleiro
    Desenhar::cor= 0xff0000ff
    0.upto(@t) do |i|
      Desenhar::linha @x + i*@tcasa, @y, @x + @tcasa*i, @y + @t*@tcasa
      Desenhar::linha @x, @y + i*@tcasa, @x + @t*@tcasa, @y + @tcasa*i
    end
    
    #desenhar pontos
    @matriz.each! do |i, j, p|
        @pontos[p-1].draw(@x+j*@tcasa, @y+i*@tcasa,1) if p > 0
    end
  end
end