class Tern
  @@v = @@f = @@x = 1
  def initialize sim
    @valor = sim
  end
  
  def + (sim)
    return @@x if @valor == :x
    return self if sim == @@f
    sim
  end
  
  def self.v
    @@v = Tern.new :v if @@v == 1
    @@v
  end
  
  def self.f
    @@f = Tern.new :f if @@f == 1
    @@f
  end
  
  def self.x
    @@x = Tern.new :x if @@x == 1
    @@x
  end
  
  def to_s
    @valor.to_s
  end
  
  def to_b
    @valor == :v
  end
end

class Resolver
  def initialize matriz, hori, vert, barra
    @matriz, @hori, @vert, @barra = matriz, hori, vert, barra
    @barra.sort!.reverse!
    @t = @matriz[0].size
  end
  
  def resolver
    if exato(1) == Tern.x
      puts "Deu erro"
    end
    #chutar 1
    normalizar
    @matriz
  end
  
  #Trasforma todos os números positivos em 1 e os negativos em -1
  def normalizar
    @matriz.each do |i|
      i.map! do |x|
        if x == 0
          x
        else
          x/x.abs
        end
      end
    end
  end
  
  def exato nivel
    mod = Tern.v
    while mod.to_b
      mod = horizontal(nivel) + vertical(nivel)
      return Tern.x if mod == Tern.x
    end
    return Tern.x if checar_barras == Tern.x and nivel > 1
    chutar nivel + 1
  end
  
  #Variável para controlar se o anterior 
  def checar_barras
    bar = [@t]*@t
    bar.map! { |m| [0]*m }
    @matriz.each_index do |i|
      h = false
      @matriz[i].each_index do |j|
        if(@matriz[i][j] > 0)
          if h
            bar[i][j] = bar[i][j-1] + 1 #havia ponto na esquerda
          else
            h = true
            if i > 0 and bar[i-1][j] > 0
              bar[i][j] = bar[i-1][j] + 1 #tem ponto acima
            else
              bar[i][j] = 1
            end
          end
        else
          bar[i][j] = 0
          h = false
        end
      end
    end
    
    #agora verificar quais barras eu encontrei
    nums = [0]*(@t+1)
    bar.each do |i|
      i.each do |j|
        nums[j] += 1
      end
    end
    x = nil
    nums.reverse!.map! do |i| 
      if x.nil?
        x = i
      else
        ant = x
        x = i
        i - ant
      end
    end
    barras = []
    nums.pop(1)
    nums.reverse!
    nums.each_index do |i|
      barras += [i+1] * nums[i]
    end
    
    barras.sort!.reverse!
    barras.each_index do |i|
      if (not @barra[i].nil?) and barras[i] > @barra[i]
        return Tern.x
      end
    end
    Tern.v
  end
  
  def desfazer nivel
    @matriz.each do |i|
      i.map! do |x|
        (x.abs < nivel) ? x : 0
      end
    end
  end
  
  def chutar nivel
    @matriz.each_index() do |i|
      @matriz[i].each_index do |j|
        if pintavel? i, j
          #puts "chute #{i}, #{j} "
          @matriz[i][j] = nivel
          res = exato nivel
          if res == Tern.x
            desfazer nivel
            @matriz[i][j] = -(nivel-1)
          else
          end
        end
      end
    end
  end
  
  def horizontal nivel
    mod = Tern.f
    @hori.each_index do |i|
      pontos = vazios = 0
      0.upto(@t-1) do |j|
        vazios += 1 if @matriz[j][i] < 0
        pontos += 1 if @matriz[j][i] > 0
      end
      return Tern.x if (@hori[i] < pontos or @t-@hori[i] < vazios)
      unless vazios + pontos == @t
        #A quantidade de espaços disponiveis é igual à quantidade exigida
        if(@hori[i] == @t - vazios)
          0.upto(@t-1) { |j| mod = mod + pintar(j, i, nivel) if @matriz[j][i] == 0 }
        end
        if(@hori[i] == pontos)
          0.upto(@t-1) { |j| mod = mod + vazio!(j, i, nivel) if @matriz[j][i] == 0 }
        end
      end
    end
    mod
  end
  
  def vertical nivel
    mod = Tern.f
    @vert.each_index do |i|
      pontos = vazios = 0
      0.upto(@t-1) do |j|
        vazios += 1 if @matriz[i][j] < 0
        pontos += 1 if @matriz[i][j] > 0
      end
      return Tern.x if (@vert[i] < pontos or @t-@vert[i] < vazios)
      unless vazios + pontos == @t
        #A quantidade de espaços disponiveis é igual à quantidade exigida
        if(@vert[i] == @t - vazios)
          0.upto(@t-1) { |j| mod = mod + pintar(i, j, nivel) if @matriz[i][j] == 0 }
        end
        if(@vert[i] == pontos)
          0.upto(@t-1) { |j| mod = mod + vazio!(i, j, nivel) if @matriz[i][j] == 0 }
        end
      end
    end
    mod
  end
  
  def pintar i, j, nivel
    if @matriz[i][j] == 0
      @matriz[i][j] = nivel
      result = vazio!(i-1, j-1, nivel) +
               vazio!(i-1, j+1, nivel) +
               vazio!(i+1, j-1, nivel) +
               vazio!(i+1, j+1, nivel)
      return Tern.v + result
    end
    Tern.f
  end
  
  #retorna false se alguma casa na diagonal já estiver pintada, true caso contrário
  def pintavel? i, j
    return false if i>0 and j>0 and @matriz[i-1][j-1] > 0
    return false if i>0 and j<@t-1 and @matriz[i-1][j+1] > 0
    return false if i<@t-1 and j>0 and @matriz[i+1][j-1] > 0
    return false if i<@t-1 and j<@t-1 and @matriz[i+1][j+1] > 0
    @matriz[i][j] == 0
  end
  
  #Tenta pintar uma casa de com vazio
  #retorna erro se a casa contém um ponto
  #retorna v ou f caso tenha ocorrido a modificação ou não
  def vazio! i, j, nivel
    return Tern.f unless i.between?(0, @t-1) and j.between?(0, @t-1) #fora da matriz
    return Tern.x if @matriz[i][j] > 0 #casa contém ponto ponto
    return Tern.f if @matriz[i][j] < 0 #já estava vazia
    @matriz[i][j] = -nivel
    return Tern.v
  end
  
  def matriz
    @matriz
  end
end
