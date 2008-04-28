# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

require 'db'

class KategoriaBydla < Db::Record
  def init
    @id = 'id_kategorii'
    @tabela = 'kategoria_bydla'
    @kolumny = ['id_kategorii','nazwa']
  end
end
