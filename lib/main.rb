#!/usr/bin/env ruby
require 'libglade2'
require 'sqlite3'
require 'db'

class Main
  # akcesor - tylko do odczytu
  attr_reader :glade
  attr_accessor :osobay_list_selected
 
  def initialize()
    # Glowy obiekt widoku, z niego wyszczegulawane sa pozostale okna
    @glade = GladeXML.new("./views/glade/main.glade", nil, "SIiRZ", nil, GladeXML::FILE) {|handler| method(handler)}
    
    # Nawiazanie polaczenia z BD
    polaczenie = SQLite3::Database.new("database.sqlite")
    Db::Record.polaczenie(polaczenie);

    # Okna..
    @main_window = @glade.get_widget('main_window');

    @osoby_window = @glade.get_widget('osoby_window');
    @osoby_list_window = @glade.get_widget('osoby_list_window');
    @treeview_osoby = @glade.get_widget('treeview_osoby');

    @uboj_window = @glade.get_widget('uboj_window');
    @gospodarstwo_window  = @glade.get_widget('gospodarstwo_window');
    
    @about_dialog  = @glade.get_widget('about_dialog');

    # Start okna glownego
    @main_window.show
  end

  #
  # Main
  #

  # akcje dla menu
  def on_menuitem_uboj_activate()
    @uboj_window.show
  end
  def on_menuitem_gospodarstwo_activate()
    @gospodarstwo_window.show
  end
  def on_menuitem_about_activate()
    @about_dialog.show
    @about_dialog.signal_connect('response') { @about_dialog.hide }
  end
  def on_menuitem_ksiegowanie_uboj_activate()
    
  end
  # akcje panelu glownego
  def on_button_osoby_clicked()
    puts 'osoby'
    @osoby_window.show
  end
  def on_button_historia_clicked()
    
  end
  def on_button_zaksiegowanie_uboju_clicked()
    
  end
  def on_button_wystawianie_faktury_clicked()
    
  end
  def on_button_wystawianie_clicked()
    
  end
  def on_button_tworzenie_plikow_clicked()
    
  end
  def on_button_druk_etykiet_clicked()
    
  end
  def on_button_przedzial_wiekowy_clicked()
    
  end
  def on_button_rasy_clicked()
    
  end
  def on_button_kategorie_bydla_clicked()
    
  end
  def on_button_zwierzeta_clicked()
    
  end
  def on_button_ubojnia_activate()
    # ﻿ta funkcja będzie dostępna w następnej wersji systemy, prosimy o cierpliwość
  end
  

  #
  # Uboj
  #
  
  # akcje panelu nawigacyjnego
  def on_button_uboj_dodaj_clicked()
    # tworzenie komunikatu
    dialog = Gtk::MessageDialog.new(nil, 
                              Gtk::Dialog::NO_SEPARATOR,
                              Gtk::MessageDialog::INFO,
                              Gtk::MessageDialog::BUTTONS_OK,
                              "Uboj został dodany")
    dialog.run
    dialog.signal_connect('response') { dialog.hide }
  end
  def on_button_uboj_zapisz_clicked()
    # tworzenie komunikatu
    dialog = Gtk::MessageDialog.new(nil, 
                              Gtk::Dialog::NO_SEPARATOR,
                              Gtk::MessageDialog::INFO,
                              Gtk::MessageDialog::BUTTONS_OK,
                              "Zmiany zostały zapisane")
    dialog.run
    dialog.signal_connect('response') { dialog.hide }
  end
  def on_button_uboj_anuluj_clicked()
    @uboj_window.hide
  end
  
  #
  # Gospodarstwo
  #
  
  # akcje panelu nawigacyjnego
  def on_button_gospodarstwo_dodaj_clicked()
    # tworzenie komunikatu
    dialog = Gtk::MessageDialog.new(nil, 
                              Gtk::Dialog::NO_SEPARATOR,
                              Gtk::MessageDialog::INFO,
                              Gtk::MessageDialog::BUTTONS_OK,
                              "Gospodarstwo zostało dodane")
    dialog.run
    dialog.signal_connect('response') { dialog.hide }
  end
  def on_button_gospodarstwo_zapisz_clicked()
    # tworzenie komunikatu
    dialog = Gtk::MessageDialog.new(nil, 
                              Gtk::Dialog::NO_SEPARATOR,
                              Gtk::MessageDialog::INFO,
                              Gtk::MessageDialog::BUTTONS_OK,
                              "Zmiany zostały zapisane")
    dialog.run
    dialog.signal_connect('response') { dialog.hide }
  end
  def on_button_gospodarstwo_anuluj_clicked()
    @gospodarstwo_window.hide
  end
  
  #
  # Osoby
  #
  
  # akcje dla okna list
  # panelu nawigacyjnego
  def on_button_osoba_dodaj_clicked()
    
  end
  def on_button_osoba_edytuj_clicked()
    
  end
  # akcje dla okna add/edit
  # panelu nawigacyjnego
  def on_button_osoby_list_clicked
    @osoby_list_window.show
    osoba = Db::Osoba.new
    tablica = osoba.wczytajWszystkie();

    model = Gtk::ListStore.new(String, String, String)
    tablica.each_index do |index|
      puts index
      iter = model.insert(index)
      iter.set_value(0,tablica[index]['id_osoby'])
      iter.set_value(1,tablica[index]['Imie'])
      iter.set_value(2,tablica[index]['Nazwisko'])
      puts index
    end

    @treeview_osoby.set_model(model)
    
#    row-activated: self, path, column
#
#        * self: the Gtk::TreeView
#        * path: the Gtk::TreePath
#        * column: the Gtk::TreeViewColumn
    # uchwyt dla kliknietego wiersza
    @treeview_osoby.signal_connect("row-activated") do |view, path, column|
       # ustawienie id rekordu ktory zostal klikniety
       # dzieki temu przycisk edytuj umozliwi nam edycje okreslonego rekordu
       @osobay_list_selected = model.get_value(model.get_iter(path),0)
    end

    # tworzenie kolumny
    @treeview_osoby.insert_column(0, "Id", Gtk::CellRendererText.new,{:text => 1})
    @treeview_osoby.insert_column(1, "Imie", Gtk::CellRendererText.new,{:text => 1})
    @treeview_osoby.insert_column(2, "Nazwisko", Gtk::CellRendererText.new,{:text => 1})
  end
  def on_button_osoby_dodaj_clicked()
    # tworzenie komunikatu
    dialog = Gtk::MessageDialog.new(nil, 
                              Gtk::Dialog::NO_SEPARATOR,
                              Gtk::MessageDialog::INFO,
                              Gtk::MessageDialog::BUTTONS_OK,
                              "Osoba została dodana")
    dialog.run
    dialog.signal_connect('response') { dialog.hide }
  end
  def on_button_osoby_zapisz_clicked()
    # tworzenie komunikatu
    dialog = Gtk::MessageDialog.new(nil, 
                              Gtk::Dialog::NO_SEPARATOR,
                              Gtk::MessageDialog::INFO,
                              Gtk::MessageDialog::BUTTONS_OK,
                              "Zmiany zostały zapisane")
    dialog.run
    dialog.signal_connect('response') { dialog.hide }
  end
  def on_button_osoby_anuluj_clicked()
    @osoby_window.hide
  end
end


# go, go, go!
Main.new
Gtk.main