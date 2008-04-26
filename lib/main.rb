#!/usr/bin/env ruby
require 'libglade2'
require 'bydlo'
require 'main_callbacks'


class Main
  # akcesor - tylko do odczytu
  attr :glade, :bydloList

  def initialize()
    # inicjowanie tylko okna glownego
    @glade = GladeXML.new("./glade/main.glade", 'mainWindow', "SIiRZ", nil, GladeXML::FILE) {|handler| method(handler)}
    #@dodajUbojWindow = @glade.get_widget("dodajUbojWindow").hide
    #@dodajGospodarstowWindow = @glade.get_widget("dodajGospodarstwoWindow").hide
    #@aboutDialog = @glade.get_widget("aboutDialog")
    
    #init_callbacks(@glade)
  end

  def on_about_activate()
    @aboutDialog.show
  end
  def on_listaGospodarstw_clicked()
    @model = Gtk::ListStore.new(String, String)
    #@model.set_value(@model.append, "File", 'value');
    
    tablica = [
        {:file => 'ok'},
        {:file => 'tuk'},
        {:file => 'puk'},
    ];

    tablica.each_index do |index|
      @model.insert(index).set_value(0,tablica[index][:file])
    end
    
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
    @dodajGospodarstowWindow.show
  end
  
  def on_uboje1_activate()
    UbojWindow.new
  end
  
  def on_zamknij_clicked()
    puts 'kliknieto zamknij'
    Gtk.main_quit
  end
end

class UbojWindow
  attr :uboj
  def initialize()
    @uboj = GladeXML.new("./glade/main.glade", "dodajUbojWindow", "SIiRZ - dodaj ubój", nil, GladeXML::FILE) {|handler| method(handler)}
    
    # Utworzenie listy bydla - bedzie z tad przeniesione!
    listaBydlo = Bydlo::Lista.new
    listaBydlo.dodaj(Bydlo::Buhaj.new)
    listaBydlo.dodaj(Bydlo::Ciele.new)
    listaBydlo.dodaj(Bydlo::Jalowka.new)
    listaBydlo.dodaj(Bydlo::Krowa.new)
    listaBydlo.dodaj(Bydlo::Wolec.new)

    # Uzupelnienie modelu
    @model = Gtk::ListStore.new(String)
    listaBydlo.dajWszystkie.each do |element|
      @model.append.set_value(0, element.dajNazwa())
    end
    
    # Lista ComboBox
    comboBoxEntry = @uboj.get_widget('kategoriaBydla');
    comboBoxEntry.model = @model
  end
end


# go, go, go!
Main.new
Gtk.main