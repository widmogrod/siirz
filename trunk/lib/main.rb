#!/usr/bin/env ruby
require 'libglade2'
require 'bydlo'
require 'singleton'
require 'action'
require 'actions/main'
require 'actions/osoba'

class Main

  # akcesor - tylko do odczytu
  attr_reader :glade
 
  def initialize()
    @glade = GladeXML.new("./views/glade/main.glade", nil, "SIiRZ", nil, GladeXML::FILE) {|handler| method(handler)}
    
    @main_window = @glade.get_widget('main_window');
    @osoby_window = @glade.get_widget('osoby_window');
    @uboj_window = @glade.get_widget('uboj_window');
    @gospodarstwo_window  = @glade.get_widget('gospodarstwo_window');
    
    @about_dialog  = @glade.get_widget('about_dialog');
    
    @main_window.show
  end

  #
  # Main
  #

  # akcje panelu glownego
  def on_button_osoby_clicked()
      @osoby_window.show
  end
  # akcje dla menu
  def on_menuitem_uboj_activate
    @uboj_window.show
  end
  def on_menuitem_gospodarstwo_activate
    @gospodarstwo_window.show
  end
  def on_menuitem_about_activate
    @about_dialog.show
    @about_dialog.signal_connect('response') { @about_dialog.hide }
  end

  #
  # Uboj
  #
  
  # akcje panelu nawigacyjnego
  def on_button_uboj_dodaj_clicked
    # tworzenie komunikatu
    dialog = Gtk::MessageDialog.new(nil, 
                              Gtk::Dialog::NO_SEPARATOR,
                              Gtk::MessageDialog::INFO,
                              Gtk::MessageDialog::BUTTONS_OK,
                              "Uboj został dodany")
    dialog.run
    dialog.signal_connect('response') { dialog.hide }
  end
  def on_button_uboj_zapisz_clicked
    # tworzenie komunikatu
    dialog = Gtk::MessageDialog.new(nil, 
                              Gtk::Dialog::NO_SEPARATOR,
                              Gtk::MessageDialog::INFO,
                              Gtk::MessageDialog::BUTTONS_OK,
                              "Zmiany zostały zapisane")
    dialog.run
    dialog.signal_connect('response') { dialog.hide }
  end
  def on_button_uboj_anuluj_clicked
    @uboj_window.hide
  end
  
  #
  # Gospodarstwo
  #
  
  # akcje panelu nawigacyjnego
  def on_button_gospodarstwo_dodaj_clicked
    # tworzenie komunikatu
    dialog = Gtk::MessageDialog.new(nil, 
                              Gtk::Dialog::NO_SEPARATOR,
                              Gtk::MessageDialog::INFO,
                              Gtk::MessageDialog::BUTTONS_OK,
                              "Gospodarstwo zostało dodane")
    dialog.run
    dialog.signal_connect('response') { dialog.hide }
  end
  def on_button_gospodarstwo_zapisz_clicked
    # tworzenie komunikatu
    dialog = Gtk::MessageDialog.new(nil, 
                              Gtk::Dialog::NO_SEPARATOR,
                              Gtk::MessageDialog::INFO,
                              Gtk::MessageDialog::BUTTONS_OK,
                              "Zmiany zostały zapisane")
    dialog.run
    dialog.signal_connect('response') { dialog.hide }
  end
  def on_button_gospodarstwo_anuluj_clicked
    @gospodarstwo_window.hide
  end
  
  #
  # Osoby
  #

  # akcje panelu nawigacyjnego
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