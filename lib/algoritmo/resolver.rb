class Resolver
  def initialize matriz, hori, vert, barra
    @matriz, @hori, @vert, @barra = matriz, hori, vert, barra
    @t = @matriz[0].size
  end
  
  def resolver nivel = 0
    mod = true
    while mod
      mod = horizontal(nivel) | vertical(nivel)
      
      
      
      
    end
  end
  
  def horizontal nivel
    mod = false
    @hori.each_index do |i|
        pontos = vazios = 0
        0.upto(@t-1) do |j|
          vazios += 1 if vazio? @matriz[i][j]
          pontos += 1 if ponto? @matriz[i][j]
        end
        unless vazios + pontos == @t
          #A quantidade de espaços disponiveis é a igual à quantidade exigida
          if(@hori[i] == @t - vazios)
            0.upto(@t-1) { |j| mod = mod | pintar(i, j, nivel) }
          end
          if(@hori[i] == pontos)
            0.upto(@t-1) { |j| mod = mod | vazio!(i, j, nivel) }
          end
        end
      end
      mod
  end
  
  def vertical nivel
    mod = false
    @vert.each_index do |i|
      pontos = vazios = 0
      0.upto(@t-1) do |j|
        vazios += 1 if vazio? @matriz[j][i]
        pontos += 1 if ponto? @matriz[j][i]
      end
      unless vazios + pontos == @t
        #A quantidade de espaços disponiveis é a igual à quantidade exigida
        if(@vert[i] == @t - vazios)
          0.upto(@t-1) { |j| mod = mod | pintar(j, i, nivel) }
        end
        if(@vert[i] == pontos)
          0.upto(@t-1) { |j| mod = mod | vazio!(j, i, nivel) }
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
      return true
    end
    false
  end
  
  def vazio! i, j, nivel
    if @matriz[i][j] == :indef
      if nivel == 0
        @matriz[i][j] = :vazio
      else
        @matriz[i][j] = -nivel
      end
      return true
    end
    false
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
