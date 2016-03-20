require 'gosu'
require_relative 'tabuleiro'

include Gosu

class Principal < Window
  Larg = 640
  Alt = 480
  def initialize
    super Larg, Alt, false
    self.caption = "Resolvedor LogicDots"
    @tab = Tabuleiro.new 100, 100
  end
  
  def update
    
  end
  
  def draw
    draw_rect(0,0, Larg, Alt, 0xffffffff, 0)
    @tab.draw
  end
  
  def needs_cursor?
    true
  end
end


janela = Principal.new
janela.show