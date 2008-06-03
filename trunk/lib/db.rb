require 'sqlite3'

module Db
  class Record
    @@connection = 1

    # ustawia polaczenie z baza
    # polaczenie bedzie dostepne we wszystkich instancjach tej klasy
    def self.polaczenie(connection)
      if !connection.is_a?(SQLite3::Database)
        raise Exception.new('Połączenie nie jest instancja `SQLite3::Database`');
      end

      @@connection = connection
    end

    def initialize
      if @@connection == nil
         raise Exception.new('Nie ustawiono polaczenia z baza danych');
      end

      # metoda inicjujaca zmienne, ktore sa nizej sprawdzane
      init

      # sprawdzenie wymaganych zmiennych
      if @tabela === nil
        raise Exception.new('Nie okreslono nazwy tabeli w BD');
      end
      if @id === nil
        raise Exception.new('Nie okreslono nazwy klucza glownego');
      end
      if @kolumny === nil || !@kolumny.is_a?(Array) || @kolumny.empty?
        raise Exception.new('Nie okreslono kolumn wystepujacych w tabeli');
      end
    end

    # dane sa przekazywane jako tablica {'klucz' => 'wartosc'}
    def dodaj(dane)
      begin
        sprawdzDane(dane)

        sql = "INSERT INTO #{@tabela} (#{dane.keys.join(', ')}) VALUES('#{dane.values.join("', '")}')"

        stmt = @@connection.prepare(sql)
        stmt.execute
        return true
      rescue Exception => e
        puts e.message
        return false
      end
    end

    # @return bool
    def edytuj(id, dane)
      begin
        sprawdzDane(dane)

        # formatowanie danych do formatu `kolumna` => 'wartosc'
        set = []
        dane.each_pair do |key, value|
          set.push("#{key} = '#{value}'")
        end
        
        sql = "UPDATE #{@tabela} SET #{set.join(', ')} WHERE #{@id} = #{id} "

        stmt = @@connection.prepare(sql)
        stmt.execute
        return true
      rescue Exception => e
        puts e.message
        return false
      end
    end

    # @return bool
    def usun(id)
      begin        
        sql = "DELETE FROM #{@tabela} WHERE #{@id} = #{id} "
        stmt = @@connection.prepare(sql)
        stmt.execute
        return true
      rescue Exception => e
        puts e.message
        return false
      end
    end

    def ostatioDodaneId
      return @@connection.last_insert_row_id
    end
    
    # @return Hash
    def wczytaj(id)
      begin        
        sql = "SELECT * FROM #{@tabela} WHERE #{@id} = #{id} LIMIT 1"

        stmt = @@connection.prepare(sql)
        stmt.execute do |results|
          hash = Hash.new
          i = 0
          results.each do |row|
            # przypisanie rekordowi kolumna => wartosc
            row.each { |item| hash[results.columns[i]] = item; i = i+1 }
            # nie powinno byc wiecej loopow bo LIMIT 1 .. ale w razie czego return ;]
            return hash
          end
        end
      rescue Exception => e
        puts e.message
        return false
      end
    end

    # @return array of Hash
    def wczytajWszystkie
      begin        
        sql = "SELECT * FROM #{@tabela}"

        # tworzenie Hash tj. {'klucz' => 'wartosc'} ..
        stmt = @@connection.prepare(sql)

        array = Array.new
        stmt.execute do |results|
          results.each do |row|
            hash = Hash.new
            i = 0
            # kazdemu rekordowi przypisuje kolumna => wartosc
            row.each do |item|
              hash[results.columns[i]] = item; i = i+1
            end
            # dodajemy do tablicy
            array.push(hash)
          end
          return array
        end
      rescue Exception => e
        puts e.message
        return false
      end
    end
    
    protected

    def sprawdzDane(dane)
      dane.each_pair do |key, value|
        if @kolumny.index(key) === nil
          raise Exception.new("W tabeli #{@tabela} nie zostala zdefiniowana klumna #{index}");
        end
      end
    end
  end
  
  
  class Osoba < Db::Record
    def init
      @id = 'id_osoby'
      @tabela = 'Osoba'
      @kolumny = ['id_osoby', 'Imie', 'Nazwisko', 'Adres', 'NIP', 'PESEL', 'Seria', 'Wazne']
    end
  end


  class Faktura < Db::Record
	def init
		  @id = 'identyfikator'
		  @tabela = 'faktura'
		  @kolumny = [  "identyfikator",  "Osoba_id_osoby",  "id_faktury",  "Wartosc netto" , "Wartosc brutto",  "Cena za kg",   "Podatek" ,  "Data zakupu" , "Data zaplaty" ,  "Zaplacono" , 
  "id_zwierzecia" , "Wazne"  ]
	end
  end

  class Kategoria_bydla < Db::Record
	  def init
		@id = 'id_kategorii'
		@tabela = 'kategoria_bydla'
		@kolumny = ['Nazwa', 'Wazne' ]
	  end
  end


  class Uboj < Db::Record
	  def init
		@id = 'id_uboju'
		@tabela = 'uboj'
		@kolumny = [    'Ubojnia_id_ubojni' ,  'Data' , 'Nr_zezni' , 'Nr_Weterynaryjny' , 'Data_wydania_decyzji_wet' , 'Szczegoly' ,  'Wazne' ]
	  end
  end

  class Zakup < Db::Record
	  def init
		@id = 'identyfikator'
		@tabela = 'zakup'
		@kolumny = [   'Faktura_identyfikator' ,  'Zwirze_id_zwierzecia' ,  'id_zakupu',   'Wazne']
	  end
  end

  class Zwierze < Db::Record
	  def init
		@id = 'id_zwierzecia'
		@tabela = 'zwierze'
		@kolumny = [    'Uboj_id_uboju',  'Plik_id_pliku',  'Rasa_id_rasy',   'Kategoria_bydla_id_kategorii',  'Przedzial_wiekowy_id_przedzialu',  'Identyfikator',   "Numer parti uboju",  "Data przyjecia do rzezni", "Data urodzenia",  "Numer stada",  "Numer Rzeni",  "Masa Ciala",  'Podpis', 'Wazne']
	  end
  end

  class Ubojnia < Db::Record
	  def init
		@id = 'id_ubojni'
		@tabela = 'ubojnia'
		@kolumny = [   'Nazwa',  'PESEL',  'REGON',  'Adres',   'Inne',   'Wazne']
	  end
  end

  class Rasa  < Db::Record
	  def init
		@id = 'id_rasy'
		@tabela = 'rasa'
		@kolumny = [   'Nazwa', 'Wazne']
	  end
  end

  class Przedzial_wiekowy  < Db::Record
	  def init
		@id = 'id_przedzialu'
		@tabela = 'przedzial_wiekowy'
		@kolumny = [   'Opis', 'Wazne']
	  end
  end


  class Plik  < Db::Record
	  def init
		@id = 'id_pliku'
		@tabela = 'plik'
		@kolumny = [    'Ubojnia_id_ubojni',  'Nazwa',  "Data utworzenia",   'Zakonczony',  'Weksportowany',  'Inne', 'Wazne']
	  end
  end

end
  
