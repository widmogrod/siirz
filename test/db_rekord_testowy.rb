# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'db'

class RekordTestowy < Db::Record
  def init
    @id = 'id_kategorii'
    @tabela = 'kategoria_bydla'
    @kolumny = ['id_kategorii','nazwa']
  end
end

class TestDbRekordsiTestowy < Test::Unit::TestCase
  def setup
    @polaczenie = SQLite3::Database.new("database.sqlite")
  end

  def test_a
    rekord = RekordTestowy.new

    assert          rekord.dodaj({'nazwa' => 'Krowa'}), 'Rekord nie zostal dodany'
    
    lastId = rekord.ostatioDodaneId

    assert_nil      rekord.wczytaj(1000), 'Nieistniejacy rekord zostal znaleziony'
    assert_not_nil  rekord.wczytaj(lastId), 'Znaleziony rekord nie jest prawidlowy'
    assert          rekord.usun(lastId), 'Rekord nie zostal uniety'
    assert_nil      rekord.wczytaj(lastId), 'Nieistniejacy rekord zostal znaleziony'
  end
end
