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
    @t = @matriz[0].size
  end
  
  def resolver nivel = 0
    mod = Tern.v
    while mod.to_b
      mod = horizontal(nivel) + vertical(nivel)
      
      
      
    end
    @matriz.each { |i| p i }
    @matriz
  end
  
  def horizontal nivel
    mod = Tern.f
    @hori.each_index do |i|
        pontos = vazios = 0
        0.upto(@t-1) do |j|
          vazios += 1 if vazio? @matriz[j][i]
          pontos += 1 if ponto? @matriz[j][i]
        end
        unless vazios + pontos == @t
          #A quantidade de espaços disponiveis é igual à quantidade exigida
          if(@hori[i] == @t - vazios)
            0.upto(@t-1) { |j| mod = mod + pintar(j, i, nivel) }
          end
          if(@hori[i] == pontos)
            0.upto(@t-1) { |j| mod = mod + vazio!(j, i, nivel) }
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
        vazios += 1 if vazio? @matriz[i][j]
        pontos += 1 if ponto? @matriz[i][j]
      end
      unless vazios + pontos == @t
        #A quantidade de espaços disponiveis é igual à quantidade exigida
        if(@vert[i] == @t - vazios)
          0.upto(@t-1) { |j| mod = mod + pintar(i, j, nivel) }
        end
        if(@vert[i] == pontos)
          0.upto(@t-1) { |j| mod = mod + vazio!(i, j, nivel) }
        end
      end
    end
    mod
  end
  
  def pintar i, j, nivel
    if @matriz[i][j] == :indef
      if nivel == 0
        @matriz[i][j] = :pont
        @matriz[i-1][j-1] = :vazio if i > 0 and j > 0
        @matriz[i-1][j+1] = :vazio if i > 0 and j < @t - 1
        @matriz[i+1][j-1] = :vazio if i < @t - 1 and j > 0
        @matriz[i+1][j+1] = :vazio if i < @t - 1 and j < @t - 1
      else
        @matriz[i][j] = nivel
      end
      return Tern.v
    end
    Tern.f
  end
  
  def vazio! i, j, nivel
    if @matriz[i][j] == :indef
      if nivel == 0
        @matriz[i][j] = :vazio
      else
        @matriz[i][j] = -nivel
      end
      return Tern.v
    end
    Tern.f
  end
  
  def vazio? n
    return true if n == :vazio
    return n < 0 if n.class == Fixnum
  end
  
  def ponto? n
    return true if n == :pont
    return n > 0 if n.class == Fixnum
  end
  
  def matriz
    @matriz
  end
end
