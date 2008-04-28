# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'db'

class TestDB < Test::Unit::TestCase
  def setup
    @polaczenie = SQLite3::Database.new("test_database.sqlite")
  end
  
  def teardown
    @polaczenie = nil
  end

  def test_polaczenie_zle
    assert_raise Exception do
        Db::Record.polaczenie('brak polaczenia');
    end
  end

  def test_polaczenie_dobre
    assert_nothing_raised do
        Db::Record.polaczenie(@polaczenie);
    end
  end
end
