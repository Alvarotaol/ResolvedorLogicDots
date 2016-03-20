require 'gosu'
module Desenhar
  @cor
  
  def cor= c
    @cor = c
  end
  
  def linha x1, y1, x2, y2
    c = Gosu::Color.new(@cor)
    Gosu::draw_line(x1, y1, c, x2, y2, c, 1)
  end
  
end
