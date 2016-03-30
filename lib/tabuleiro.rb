require_relative 'desenhar'
include Desenhar

class Tabuleiro
  attr_reader :matriz
  attr_accessor :tcasa, :pontos
  
  INDEF = 0x0
  VAZIO = 0x01
  PONT = 0x02
  CIMA = 0x04
  DIR = 0x08
  BAIXO = 0x10
  ESQ = 0x20
  VERT = CIMA + BAIXO
  HORI = DIR + ESQ
  LIVRE = 0x40
  
  def initialize(x,y, t=5)
    @mapa = {indef: 0, vazio: 1, pont: 2, cima: 3,
            dire: 4, baixo: 5, esq: 6, vert: 7, hori: 8, decre: -1, incre: 1}
   
    @x = x
    @y = y
    @t = t
    @tcasa = 20
    @matriz = [@t]*@t
    @matriz.map! { |m| [0]*m }
    
  end
  
  def tamanho= t
    @t = t
    @matriz = [@t]*@t
    @matriz.map! { |m| [0]*m }
  end
  
  def clicar x, y, d
    dx = x - @x
    dy = y - @y
    return false if(dx < 0 or dy < 0 or dx >= @tcasa*@t or dy >= @tcasa*@t)
    dx /= @tcasa
    dy /= @tcasa
    if(d == :decre or d == :incre)
      @matriz[dy][dx] = prox @matriz[dy][dx], d
    else
      @matriz[dy][dx] = simb_hex d
    end
    true
  end
  
  def converter
    m=[]
    completar
    @matriz.each do |i|
      m.push([])
      i.each() do |j|
        case j
        when INDEF
          m[-1].push(:indef)
        when VAZIO, VAZIO+LIVRE
          m[-1].push(:vazio)
        else
          m[-1].push(:pont)
        end
      end
    end
    m
  end
  
  def carregar m
    self.tamanho = m.length
    resposta m
  end
  
  def resposta m
    m.each_index do |i|
      m[i].each_index do |j|
        el = nil
        case m[i][j]
        when :indef
          el = INDEF
        when :vazio
          el = VAZIO
        when :pont
          el = LIVRE
        end
        @matriz[i][j] = el unless @matriz[i][j].between?(VAZIO, LIVRE-1)
      end
    end
  end
  
  def draw
    #desenhar tabuleiro
    Desenhar::cor= 0xff0000ff
    0.upto(@t) do |i|
      Desenhar::linha @x + i*@tcasa, @y, @x + @tcasa*i, @y + @t*@tcasa
      Desenhar::linha @x, @y + i*@tcasa, @x + @t*@tcasa, @y + @tcasa*i
    end
    #desenhar células
    @matriz.each_index do |i|
      @matriz[i].each_index do |j|
        valor = @matriz[i][j]
        if valor == LIVRE
          valor += CIMA if i > 0 and @matriz[i-1][j].between?(PONT, LIVRE)
          valor += DIR if j < @t-1 and @matriz[i][j+1].between?(PONT, LIVRE)
          valor += BAIXO if i < @t-1 and @matriz[i+1][j].between?(PONT, LIVRE)
          valor += ESQ if j > 0 and @matriz[i][j-1].between?(PONT, LIVRE)
        end
        draw_cel i, j, valor
      end
    end
  end
  
  private
  
  def prox m, d
    if d == :incre
      case m
      when INDEF
        return VAZIO
      when ESQ
        return VERT
      when HORI
        return INDEF
      else
        return m * 2
      end
    else
      case m
      when INDEF
        return HORI
      when VERT
        return ESQ
      else
        return m / 2
      end
    end
  end
  
  def simb_hex n
    case n
    when :indef
      return INDEF
    when :vazio
      return VAZIO
    when :pont
      return PONT
    when :cima
      return CIMA
    when :dir
      return DIR
    when :baixo
      return BAIXO
    when :esq
      return ESQ
    when :vert
      return VERT
    when :hori
      return HORI
    end
  end
  
  def preencher_redor x, y
    p = @matriz[x][y]
    if p.between?(PONT, LIVRE)
      @matriz[x-1][y-1] = VAZIO + LIVRE if x>0 and y>0 and disp? @matriz[x-1][y-1]
      @matriz[x-1][y+1] = VAZIO + LIVRE if x>0 and y<@t-1 and disp? @matriz[x-1][y+1]
      @matriz[x+1][y-1] = VAZIO + LIVRE if x<@t-1 and y>0 and disp? @matriz[x+1][y-1]
      @matriz[x+1][y+1] = VAZIO + LIVRE if x<@t-1 and y<@t-1 and disp? @matriz[x+1][y+1]
      @matriz[x-1][y] = VAZIO + LIVRE if x>0 and [BAIXO,PONT].include?(p) and disp? @matriz[x-1][y]
      @matriz[x][y-1] = VAZIO + LIVRE if y>0 and [DIR,PONT].include?(p) and disp? @matriz[x][y-1]
      @matriz[x][y+1] = VAZIO + LIVRE if y<@t-1 and [ESQ,PONT].include?(p) and disp? @matriz[x][y+1]
      @matriz[x+1][y] = VAZIO + LIVRE if x<@t-1 and [CIMA,PONT].include?(p) and disp? @matriz[x+1][y]
    end
  end
  
  def completar
    @matriz.each_index do |i|
      @matriz[i].each_index do |j|
        preencher_redor i, j
        p = @matriz[i][j]
        if p & CIMA != 0 and i > 0
          @matriz[i-1][j] = LIVRE
          preencher_redor i-1, j
        end
        if p & BAIXO != 0 and i < @t-1
          @matriz[i+1][j] = LIVRE
          preencher_redor i+1, j
        end
        if p & DIR != 0 and j < @t-1
          @matriz[i][j+1] = LIVRE
          preencher_redor i, j+1
        end
        if p & ESQ != 0 and j > 0
          @matriz[i][j-1] = LIVRE
          preencher_redor i, j-1
        end
      end
    end
  end
  
  def disp? p
    (p == INDEF or p >= LIVRE)
  end
  
  def draw_cel x, y, v
    dv = v
    if dv >= LIVRE
      dv -= LIVRE
      cor= 0xffffffff
    else
      cor= 0xffaaaaaa
    end
    desenho = nil
    case dv
    when VAZIO
      desenho = @pontos[0]
    when PONT
      desenho = @pontos[1]
    when CIMA
     desenho =  @pontos[2]
    when DIR
      desenho = @pontos[3]
    when BAIXO
      desenho = @pontos[4]
    when ESQ
      desenho = @pontos[5]
    when VERT
      desenho = @pontos[6]
    when HORI
      desenho = @pontos[7]
    end
    desenho.draw(@x+y*@tcasa, @y+x*@tcasa,1, 1, 1, cor) unless desenho.nil?
    #Desenhar.texto dv.to_s, @x+y*@tcasa, @y+x*@tcasa
  end
end