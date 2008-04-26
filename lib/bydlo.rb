module Bydlo

  module Zwierze
    attr :nazwa
    def getNazwa
        return @nazwa
    end
  end

  class Ciele
    include Zwierze
    def initialize
      @nazwa = "Ciele"
    end
  end
  
  class Jalowka
    include Zwierze
    def initialize
      @nazwa = "Jałówka"
    end
  end
  
  class Krowa
    include Zwierze
    def initialize
      @nazwa = "Krowa"
    end
  end

  class Buhaj
    include Zwierze
    def initialize
      @nazwa = "Buhaj"
    end
  end

  class Wolec
    include Zwierze
    def initialize
      @nazwa = "Wolec"
    end
  end

  # Kolekcja zwierzat
  class Lista
    attr :zwierzeta
    def initialize
      @zwierzeta = []
    end

    def dodaj(zwierze)
      # czy instancja odpowiedniej klasy
      if !zwierze.kind_of? Bydlo::Zwierze
        #puts 'Przekazany obiekt nie jest typu `Zwierze`'
        return false;
      end

      # juz dodano
      if @zwierzeta.include?(zwierze)
        return false;
      end

      @zwierzeta.push(zwierze)
      return true;
    end
  end
end