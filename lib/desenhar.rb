require 'gosu'
module Desenhar
  attr_accessor :cor, :window, :fonte

  def linha x1, y1, x2, y2
    Gosu::draw_line(x1, y1, @cor, x2, y2, @cor, 2)
  end
  
  def ret x, y, l, a
    Gosu::draw_rect(x, y, l, a, @cor, 2)
  end
  
  def texto txt, x, y, tam
    #fonte = Gosu::Font.new(@window, Gosu::default_font_name, tam)
    fonte.draw(txt, x, y, 2, 1, 1, @cor)
    
  end
end
