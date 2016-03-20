require 'gosu'
require_relative 'tabuleiro'
require_relative 'botao'

include Gosu

class Principal < Window
  Larg = 640
  Alt = 480
  def initialize
    super Larg, Alt, false
    self.caption = "Resolvedor LogicDots"
    @tab = Tabuleiro.new 10, 120
    @tab.tcasa = 25
    @bot = []
    0.upto(9) { |i| 
      #puts "#{10+50*(i % 5)}, #{20}, #{30}, #{50}"
      @bot[i] = Botao.new 10+70*(i % 5), 20+50*(i/5), 50, 30, "#{i+5}x#{i+5}", i+5
    }
    
    Desenhar::window = self
    Desenhar::fonte = Gosu::Font.new(self, Gosu::default_font_name, 20)
  end
  
  def update
    if button_down?(MsLeft)
      @bot.each { |b| @tab.tamanho = b.valor if b.contemPonto?(mouse_x, mouse_y) }
    end
  end
  
  def draw
    draw_rect(0,0, Larg, Alt, 0xffffffff, 0)
    @tab.draw
    @bot.each do |b|
      b.draw
    end
    
  end
  
  def needs_cursor?
    true
  end
end


janela = Principal.new
janela.show