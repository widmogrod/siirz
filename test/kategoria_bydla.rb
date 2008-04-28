# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'db'

class TestKategoriaBydla < Test::Unit::TestCase
  def setup
    @polaczenie = SQLite3::Database.new("test_database.sqlite")
  end

  def test_a
    zwierze = KategoriaBydla.new
    assert          zwierze.dodaj({'nazwa' => 'Krowa'}), 'Rekord nie zostal dodany'
    assert_nil      zwierze.wczytaj(1000), 'Nieistniejacy rekord zostal znaleziony'
    assert_not_nil  zwierze.wczytaj(1), 'Znaleziony rekord nie jest prawidlowy'
  end
end
