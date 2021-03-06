require 'gosu'
require_relative 'tabuleiro'
require_relative 'botao'
require_relative 'algoritmo/resolver'

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
      @bot[i].visivel = false
    }
    @botnovo = Botao.new 10, 20, 50, 30, "Novo", :btnnovo
    @botescr = Botao.new(370, 20, 100, 30, "Escrever", :btnescrever)
    @tinput = TextInput.new
    
    @tab.pontos = Gosu::Image::load_tiles(self, "../assets/pontos.png", 25, 25, false)
    
    
    
    Desenhar::window = self
    Desenhar::fonte = Gosu::Font.new(self, Gosu::default_font_name, 20)
    ler_arquivo
    
  end
  
  def ler_arquivo
    a = File.new("ult.lgc", "r")
    l = a.readline
    m = []
    m[0] = l.split(" ").map { |i| i.to_i}
    t = m[0].size
    1.upto(t-1) { |i| m[i] = a.readline.split(" ").map { |i| i.to_i } }
    
    @tab.carregar(m);
    @tinput.text = a.readline + a.readline + a.readline
    
  end
  
  def gravar_arquivo m
    a = File.new("ult.lgc", "w")
    m.each { |i| a.write(i.join(" ")+"\n") }
    a.write(n_hori.join(" ")+"\n")
    a.write(n_vert.join(" ")+"\n")
    a.write(n_barras.join(" ")+"\n")
  end
  
  def update
    #self.caption = @tinput.text
  end
  
  def botoes_n visivel
    @bot.each { |b| b.visivel = visivel if b.valor.class == Fixnum }
  end
  
  def draw
    draw_rect(0,0, Larg, Alt, 0xffffffff, 0)
    @tab.draw
    @bot.each do |b|
      b.draw
    end
    @botnovo.draw
    @botescr.draw
    Desenhar::texto(@tinput.text, 370, 70)
    
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
        @tab.clicar(mouse_x, mouse_y, :dir)
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
      if(self.text_input.nil?)
        close
      else
        self.text_input = nil
        @botescr.txt = "Escrever"
      end
    when KbSpace
      if self.text_input.nil?
        m = @tab.converter
        #gravar_arquivo m
        @resolver = Resolver.new m, n_hori, n_vert, n_barras
        temp = @resolver.resolver()
        @tab.resposta(temp)
      end
    when KbReturn
      @tinput.text += "\n" unless self.text_input.nil?
    when MsLeft
      testar.call(:incre)
      
      #botão de novo
      if @botnovo.contemPonto?(mouse_x, mouse_y)
        botoes_n true
        @botnovo.visivel = false
        return nil#necessário para evitar cliques no botão logo abaixo
      end
      
      if @botescr.contemPonto?(mouse_x, mouse_y)
        if(self.text_input.nil?)
          self.text_input = @tinput
          @botescr.txt = "Parar"
        else
          self.text_input = nil
          @botescr.txt = "Escrever"
        end
      end
      #teste se clicou em um botão de número
      @bot.each do |b|
        if b.contemPonto?(mouse_x, mouse_y)
          @tab.tamanho = b.valor
          botoes_n false
          @botnovo.visivel = true
        end
      end
      
    when MsRight
      testar.call(:decre)
    end
  end
  
  def n_hori
    @tinput.text.split("\n")[0].split(' ').map { |l| l.to_i } 
  end
  
  def n_vert
    @tinput.text.split("\n")[1].split(' ').map { |l| l.to_i }
  end
  
  def n_barras
    @tinput.text.split("\n")[2].split(' ').map { |l| l.to_i }
  end
  
end


janela = Principal.new
janela.show


#matriz = [[:indef, :indef, :indef, :pont, :indef],
#          [:indef, :indef, :indef, :indef, :indef],
#          [:indef, :pont, :indef, :indef, :indef],
#          [:indef, :indef, :indef, :vazio, :indef],
#          [:indef, :indef, :indef, :indef, :indef]]
#hori = [2, 1, 3, 1, 1]
#vert = [0, 3, 0, 3, 2]
#barra = [3, 2, 2, 1]
#res = Resolver.new(matriz, hori, vert, barra)
#res.resolver()
#p res.matriz