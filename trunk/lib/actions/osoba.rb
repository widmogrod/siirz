# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 
module Actions
  class Osoba < Action
    def initialize()
      @view = GladeXML.new("./views/glade/main.glade", 'osoby_window', "SIiRZ", nil, GladeXML::FILE) {|handler| method(handler)}
      @window = @view.get_widget('osoby_window');
    end
    
    def pokaz
      @window.show
    end
    
    def on_button_dodaj_clicked()
      dialog = Gtk::MessageDialog.new(nil, 
                                Gtk::Dialog::NO_SEPARATOR,
                                Gtk::MessageDialog::INFO,
                                Gtk::MessageDialog::BUTTONS_OK,
                                "Osoba została dodana")
      dialog.run
      dialog.signal_connect('response') { dialog.hide }
    end
    def on_button_zapisz_clicked()
      dialog = Gtk::MessageDialog.new(nil, 
                                Gtk::Dialog::NO_SEPARATOR,
                                Gtk::MessageDialog::INFO,
                                Gtk::MessageDialog::BUTTONS_OK,
                                "Zmiany zostały zapisane")
      dialog.run
      dialog.signal_connect('response') { dialog.hide }
    end
    def on_button_anuluj_clicked()
      @window.hide
    end
  end
end