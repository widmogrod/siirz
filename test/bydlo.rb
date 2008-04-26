# 
# Test modulu zwierze
 

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'bydlo'

class TestBydlo < Test::Unit::TestCase
  def setup
    @listaBydla = Bydlo::Lista.new;
  end
  
  # upewnienie się, czy można dodać tylko zwierze implementujace modul `Zwierze::Zwierze`
  def test_dodaj
    assert(@listaBydla.dodaj(Bydlo::Krowa.new), 'Bydlo::Krowa.new nie zostalo dodane')
    assert(!@listaBydla.dodaj([1..8]), '(array) zostalo dodane')
    assert(!@listaBydla.dodaj('text'), '(string) zostalo dodane')
  end
end
