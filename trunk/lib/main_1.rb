#!/usr/bin/env ruby
require 'libglade2'
require 'bydlo'
require 'singleton'
require 'action'
require 'actions/main'
require 'actions/osoba'

class Main
  include GetText
  # akcesor - tylko do odczytu
  attr_reader :glade, :bydloList
  
  @akcje = Hash.new

  def initialize()
    # inicjowanie tylko okna glownego

    # {|handler| method(handler)} <-- przekazuje wywolywanie akcji
    # zdefiniowanych w `glade` dla obiektu `mainWindow` w tej klasie
    #@glade = GladeXML.new("./views/glade/main.glade", nil, "SIiRZ", nil, GladeXML::FILE) {|handler| method(handler)}
    
    #@akcje << {
    #  'main' => Action::Main.new(@glade.get_widget('main_window')),
    #  'osoba' => Action::Osoba.new(@glade.get_widget('osoby_window'))
    #}
    @mainAction = Actions::Main.instance
    @mainAction.pokaz
  end

  def wywolaj_obsluge_akcji(akcja)
   
  end
  
   # Uchwyty akcji - wszystkie definiowane w glade
  
  def on_button_osoby_clicked()
    put 'on_button_osoby_clicked'
  end
  
  def on_about_activate()
    @aboutDialog.show
  end
  
  def on_gospodarstwa1_activate
  end
  def on_zakoncz1_activate  
  end
  def on_partie1_activate
  end
  # proste akcje po kliknieciu buttona `lista Gospodarstw`
  def on_listaGospodarstw_clicked()
    # (String, String) <-- okresla typy kolumn
    @model = Gtk::ListStore.new(String, String)
    #@model.set_value(@model.append, "File", 'value');
    
    tablica = [
        {:file => 'ok'},
        {:file => 'tuk'},
        {:file => 'puk'},
    ];

    # wypelnianie modelu
    tablica.each_index do |index|
      @model.insert(index).set_value(0,tablica[index][:file])
    end
    
    # tworzenie kolumny
    column = Gtk::TreeViewColumn.new("File",Gtk::CellRendererText.new,{ :text => 0, :background => 1 })

    # nic innego jak Gtk::TreeView
    @listview = @glade.get_widget("treeview_listaGospodarstw");
    @listview.set_model(@model)
    @listview.append_column(column)
  end

  def on_zapisz_listaGospodarstw_clicked()
	text = @glade.get_widget("nazwaUbojni").text
        @model.insert(1).set_value(0,text)
  end
  def on_dodajGospodarstwo_clicked()

  end
  
  def on_uboje1_activate()
    UbojWindow.new(self)
  end
  
  def on_zamknij_clicked()
    puts 'kliknieto zamknij'
    Gtk.main_quit
  end
end

# TODO Rozpoczecie budowy pseldo adaptera ..
class Window
  attr_reader :main
  def initialize(mainWindow)
    @@main = mainWindow;

    init()
  end
  
  def on_zapiszToolButton_clicked()
    puts 'kliknieto zapisz'
  end
end

class UbojWindow < Window 
  attr_reader :uboj
  def init
    # pobranie z xml okna `dodajUbojWindow` <- tak nazwalem to okno w glade
    @uboj = GladeXML.new("./glade/main.glade", "dodajUbojWindow", "SIiRZ - dodaj ubój", nil, GladeXML::FILE) {|handler| method(handler)}
    
    # Utworzenie listy bydla - bedzie z tad przeniesione!
    # ADD: Te dane beda pobierane z bazy danych
    listaBydlo = Bydlo::Lista.new
    listaBydlo.dodaj(Bydlo::Buhaj.new)
    listaBydlo.dodaj(Bydlo::Ciele.new)
    listaBydlo.dodaj(Bydlo::Jalowka.new)
    listaBydlo.dodaj(Bydlo::Krowa.new)
    listaBydlo.dodaj(Bydlo::Wolec.new)

    # Uzupelnienie modelu
    @model = Gtk::ListStore.new(String)
    # dla kazdego elementu z listy
    listaBydlo.dajWszystkie.each do |element|
      # dodaj do modelu 0 - oznacza kolumne, 2 arg. jest to nazwa zwierzecia
      @model.append.set_value(0, element.dajNazwa())
    end
    
    # Lista ComboBox - rowniez nazwa ustalona w glade
    comboBoxEntry = @uboj.get_widget('kategoriaBydla');
    # ustawienie modelu w glade
    comboBoxEntry.model = @model
  end
  
  # Uchwyty akcji
  
  def on_zapiszToolButton_clicked()
    puts 'kliknieto zapisz'
    comboBoxEntry = @uboj.get_widget('kategoriaBydla');
    puts comboBoxEntry.active_text
    #puts comboBoxEntry.model.get_value('1',0)
  end
end


# go, go, go!
Main.new
Gtk.main