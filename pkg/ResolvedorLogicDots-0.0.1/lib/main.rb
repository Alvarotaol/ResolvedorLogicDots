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
    
    @tab.pontos = Gosu::Image::load_tiles(self, "../assets/pontos.png", 25, 25, false)
    

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
  
  def button_down(id)
    testar = lambda do |sim|
      if(button_down? KbW)
        @tab.clicar(mouse_x, mouse_y, :cima)
      elsif(button_down? KbX)
        @tab.clicar(mouse_x, mouse_y, :baixo)
      elsif(button_down? KbA)
        @tab.clicar(mouse_x, mouse_y, :esq)
      elsif(button_down? KbD)
        @tab.clicar(mouse_x, mouse_y, :dire)
      elsif(button_down? KbS)
        @tab.clicar(mouse_x, mouse_y, :pont)
      elsif(button_down? KbQ)
        @tab.clicar(mouse_x, mouse_y, :vert)
      elsif(button_down? KbE)
        @tab.clicar(mouse_x, mouse_y, :hori)
      elsif(button_down? KbZ)
        @tab.clicar(mouse_x, mouse_y, :vazio)
      elsif(button_down? KbC)
        @tab.clicar(mouse_x, mouse_y, :indef)
      else
        @tab.clicar(mouse_x, mouse_y, sim)
      end
    end
    
    case id
    when KbEscape
      close
    when KbSpace
      @tab.converter
    when MsLeft
      testar.call(:incre)
    when MsRight
      testar.call(:decre)
    end
  end
  
end


janela = Principal.new
janela.show