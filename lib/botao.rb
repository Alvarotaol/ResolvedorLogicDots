require_relative 'desenhar'

class Botao
  attr_accessor :x, :y, :l, :a, :txt, :valor
  def initialize x, y, l, a, txt='', valor=0
    @x, @y, @l, @a = x, y, l, a
    @txt = txt
    @valor = valor
  end
  
  def contemPonto? x, y
    (x >= @x && x < @x+@l) && (y >= @y && y < @y+@a)
  end
  
  def draw
    Desenhar::cor = 0xff5555ff
    Desenhar::ret @x, @y, @l, @a
    Desenhar::cor = 0xff000000
    Desenhar::texto @txt, @x, @y, 20
  end
end
