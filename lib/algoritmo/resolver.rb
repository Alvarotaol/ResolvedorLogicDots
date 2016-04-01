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
  
  def resolver
    if exato(0) == Tern.x
      puts "Deu erro"
    end
    @matriz.each { |i| p i }
    chutar 1
    normalizar
    @matriz.each { |i| p i }
    @matriz
  end
  
  def normalizar
    
    @matriz.each do |i|
      i.map! do |x|
        if x.class == Fixnum
          x > 0 ? :pont : :vazio
        else
          x
        end
      end
    end
  end
  
  def exato nivel
    mod = Tern.v
    while mod.to_b
      mod = horizontal(nivel) + vertical(nivel)
      return Tern.x if mod == Tern.x
      #chutar nivel + 1
    end
  end
  
  def desfazer nivel
    @matriz.each do |i|
      i.map! do |x|
        if x.class == Fixnum
          (x.abs < nivel) ? x : :indef
        else
          x
        end
      end
    end
  end
  
  def chutar nivel
    @matriz.each_index() do |i|
      @matriz[i].each_index do |j|
        if @matriz[i][j] == :indef
          puts "chute #{i}, #{j} "
          res = pintar i, j, nivel
          if res == Tern.x
            puts "ponto perto"
            despintar i, j, nivel
            vazio!(i, j, nivel-1)
          else
            res2 = exato nivel
            if res2 == Tern.x
              desfazer nivel
              vazio!(i, j, nivel-1)
            else
            end
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
        vazios += 1 if vazio? @matriz[j][i]
        pontos += 1 if ponto? @matriz[j][i]
      end
      return Tern.x if (@hori[i] < pontos or @t-@hori[i] < vazios)
      unless vazios + pontos == @t
        #A quantidade de espaços disponiveis é igual à quantidade exigida
        if(@hori[i] == @t - vazios)
          0.upto(@t-1) { |j| mod = mod + pintar(j, i, nivel) if @matriz[j][i] == :indef }
        end
        if(@hori[i] == pontos)
          0.upto(@t-1) { |j| mod = mod + vazio!(j, i, nivel) if @matriz[j][i] == :indef }
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
      return Tern.x if (@vert[i] < pontos or @t-@vert[i] < vazios)
      unless vazios + pontos == @t
        #A quantidade de espaços disponiveis é igual à quantidade exigida
        if(@vert[i] == @t - vazios)
          0.upto(@t-1) { |j| mod = mod + pintar(i, j, nivel) if @matriz[i][j] == :indef }
        end
        if(@vert[i] == pontos)
          0.upto(@t-1) { |j| mod = mod + vazio!(i, j, nivel) if @matriz[i][j] == :indef }
        end
      end
    end
    mod
  end
  
  def pintar i, j, nivel
    if @matriz[i][j] == :indef
      @matriz[i][j] = (nivel == 0 ? :pont : nivel)
      result = vazio!(i-1, j-1, nivel) +
               vazio!(i-1, j+1, nivel) +
               vazio!(i+1, j-1, nivel) +
               vazio!(i+1, j+1, nivel)
      return Tern.v + result
    end
    Tern.f
  end
  
  def despintar i, j, nivel
    @matriz[i][j] = :indef
    @matriz[i-1][j-1] = :indef if i>0 and j>0 and @matriz[i-1][j-1] == -nivel
    @matriz[i-1][j+1] = :indef if i>0 and j<@t-1 and @matriz[i-1][j+1] == -nivel
    @matriz[i+1][j-1] = :indef if i<@t-1 and j>0 and @matriz[i+1][j-1] == -nivel
    @matriz[i+1][j+1] = :indef if i<@t-1 and j<@t-1 and @matriz[i+1][j+1] == -nivel
  end
  
  def vazio! i, j, nivel
    return Tern.f unless i.between?(0, @t-1) and j.between?(0, @t-1)
    return Tern.x unless @matriz[i][j] == :indef or vazio? @matriz[i][j]
    return Tern.f if @matriz[i][j] == :vazio or @matriz[i][j]
    if nivel == 0
      @matriz[i][j] = :vazio
    else
      @matriz[i][j] = -nivel if @matriz == :indef or @matriz[i][j] > -nivel
    end
    return Tern.v
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
