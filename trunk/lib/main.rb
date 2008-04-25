#!/usr/bin/env ruby
require 'libglade2'
require 'main_callbacks'


class Main
  # akcesor - tylko do odczytu
  attr :glade

  def initialize()
    # inicjowanie tylko okna glownego
    @glade = GladeXML.new("./glade/main.glade", nil, "SIiRZ", nil, GladeXML::FILE) {|handler| method(handler)}
    @dodajUbojWindow = @glade.get_widget("dodajUbojWindow").hide
    @dodajGospodarstowWindow = @glade.get_widget("dodajGospodarstwoWindow").hide
    @aboutDialog = @glade.get_widget("aboutDialog")
    
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
  def on_zamknij_clicked()
    puts 'kliknieto zamknij'
    Gtk.main_quit
  end
end

# go, go, go!
Main.new
Gtk.main