# 
# Kontroller akcji glownej

module Actions
  class Main < Action
    def initialize()
      @view = GladeXML.new("./views/glade/main.glade", nil, "SIiRZ", nil, GladeXML::FILE) {|handler| self.method(handler)}
    end

    def pokaz
      @view.get_widget('main_window').show
    end

    def on_button_osoby_clicked()
      puts 'on_button_osoby_clicked'
    end
    def on_gospodarstwa1_activate()
      puts 'on_gospodarstwa1_activate'
    end
    def on_listaGospodarstw_clicked()
      puts 'on_gospodarstwa1_activate'
    end
    def on_zakoncz1_activate
      puts 'on_zakoncz1_activate'
    end
    def on_partie1_activate
      puts 'on_partie1_activate'
    end
    def on_zapisz_listaGospodarstw_clicked()
	#text = @glade.get_widget("nazwaUbojni").text
        #@model.insert(1).set_value(0,text)
    end
    def on_dodajGospodarstwo_clicked()
      puts 'on_dodajGospodarstwo_clicked'
    end
    def on_uboje1_activate()
      UbojWindow.new(self)
    end
    def on_zamknij_clicked()
      puts 'kliknieto zamknij'
      Gtk.main_quit
    end
    def on_zapiszToolButton_clicked()
      puts 'kliknieto zapisz'
    end
    def on_about_activate()
      #@aboutDialog.show
    end
  end
end