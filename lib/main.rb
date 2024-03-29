#!/usr/bin/env ruby
require 'libglade2'
require 'sqlite3'
require 'db'

class Main
  # akcesor - tylko do odczytu
  attr_reader :glade, :polaczenie
  attr_accessor :osobay_list_selected_id
 
  def initialize()
    # Glowy obiekt widoku, z niego wyszczegulawane sa pozostale okna
    @glade = GladeXML.new("./views/glade/main.glade", nil, "SIiRZ", nil, GladeXML::FILE) {|handler| method(handler)}
    
    # Nawiazanie polaczenia z BD
    @polaczenie = SQLite3::Database.new("database.sqlite")
    Db::Record.polaczenie(@polaczenie);
    #sql = "INSERT INTO `Osoba` (`Adres`, `Imie`, `Seria`, `Nazwisko`, `PESEL`, `NIP`) VALUES('31-314 Krakow ul. Wyzwolenia nr: 132', 'Anna', '', 'Mazur', '48150815355', '577-193-63-66')";
    #stmt = @polaczenie.prepare(sql)
    #stmt.execute

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

  def on_toolbutton_zamknij_clicked
    @osoby_list_window.hide
  end
  
  def on_toolbutton_zamknij2_clicked
    @list_window.hide
  end
  
  def on_treeview_list_window_destroy
    @list_window.hide
  end
  
  def on_list_window_destroy
    @list_window.hide
  end

  def on_main_window_destroy
    @polaczenie.close
    exit(1)
  end
  
  
  # akcje dla menu
  def on_imagemenuitem_zakoncz_activate
    @polaczenie.close
    exit(1)
  end
  def on_menuitem_uboj_activate()
    @uboj_window.show

    #kategorie bydla
    kategoria_bydla = Db::Kategoria_bydla.new
    tablica = kategoria_bydla.wczytajWszystkie
    
    combobox_kategoria = @glade.get_widget('combobox_kategoria');
    
    model = Gtk::ListStore.new(String)
    tablica.each_index do |index|
      model.append.set_value(0, tablica[index]['Nazwa'])
    end
    
    combobox_kategoria.model = model
    combobox_kategoria.set_active(0)
    
    # rasa
    rasa = Db::Rasa.new
    tablica = rasa.wczytajWszystkie
    
    combobox_rasa = @glade.get_widget('combobox_rasa');
    
    model = Gtk::ListStore.new(String)
    tablica.each_index do |index|
      model.append.set_value(0, tablica[index]['Nazwa'])
    end
    
    combobox_rasa.model = model
    combobox_rasa.set_active(0)
    
    # rasa
    przedzial_wiekowy = Db::Przedzial_wiekowy.new
    tablica = przedzial_wiekowy.wczytajWszystkie
    
    combobox_przedzial_wiekowy = @glade.get_widget('combobox_przedzial_wiekowy');
    
    model = Gtk::ListStore.new(String)
    tablica.each_index do |index|
      model.append.set_value(0, tablica[index]['Opis'])
    end
    
    combobox_przedzial_wiekowy.model = model
    combobox_przedzial_wiekowy.set_active(0)
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
  def on_button_faktura_clicked
    @osoby_list_window.show
    rasy = Db::Faktura.new
    tablica = rasy.wczytajWszystkie();

    model = Gtk::ListStore.new(String, String, String, String, String, String, String)
    tablica.each_index do |index|
      arr = tablica[index];
      row = model.insert(index)

      row.set_value(0,arr['identyfikator'])
      row.set_value(1,arr['Wartosc netto'])
      row.set_value(2,arr['Cena za kg'])
      row.set_value(3,arr['Podatek'])
      row.set_value(4,arr['Data zakupu'])
      row.set_value(5,arr['Data zaplaty'])
      row.set_value(6,arr['Zaplacono'])
    end

    @treeview_osoby.set_model(model)
    @treeview_osoby.signal_connect("row-activated") do |view, path, column|
      @osobay_list_selected_id = model.get_value(model.get_iter(path),0)
    end
    
    #czyszczenie kolun!
    @treeview_osoby.columns.each do |key|
      @treeview_osoby.remove_column(key);
    end

    @treeview_osoby.insert_column(0, "Identyfikator", Gtk::CellRendererText.new,{:text => 0 })
    @treeview_osoby.insert_column(1, "Wartosc netto", Gtk::CellRendererText.new,{:text => 1})  
    @treeview_osoby.insert_column(2, "Cena za kg", Gtk::CellRendererText.new,{:text => 2 })
    @treeview_osoby.insert_column(3, "Data zakupu", Gtk::CellRendererText.new,{:text => 3})  
    @treeview_osoby.insert_column(4, "Data zakupu", Gtk::CellRendererText.new,{:text => 4 })
    @treeview_osoby.insert_column(5, "Data zaplaty", Gtk::CellRendererText.new,{:text => 5})  
    @treeview_osoby.insert_column(6, "Zaplacono", Gtk::CellRendererText.new,{:text => 6 })
  end
  def on_button_plik_clicked
    @osoby_list_window.show
    rasy = Db::Plik.new
    tablica = rasy.wczytajWszystkie();

    model = Gtk::ListStore.new(String, String, String, String, String)
    tablica.each_index do |index|
      arr = tablica[index];
      row = model.insert(index)

      row.set_value(0,arr['id_pliku'])
      row.set_value(1,arr['Nazwa'])
      row.set_value(2,arr['[Data utworzenia]'])
      row.set_value(3,arr['Zakonczony'])
      row.set_value(4,arr['Weksportowany'])
    end

    @treeview_osoby.set_model(model)
    @treeview_osoby.signal_connect("row-activated") do |view, path, column|
      @osobay_list_selected_id = model.get_value(model.get_iter(path),0)
    end

     #czyszczenie kolun!
    @treeview_osoby.columns.each do |key|
      @treeview_osoby.remove_column(key);
    end

    @treeview_osoby.insert_column(0, "Identyfikator", Gtk::CellRendererText.new,{:text => 0 })
    @treeview_osoby.insert_column(1, "Nazwa", Gtk::CellRendererText.new,{:text => 1})  
    #   @treeview_osoby.insert_column(2, "Data", Gtk::CellRendererText.new,{:text => 2 })
    @treeview_osoby.insert_column(3, "Zakonczony", Gtk::CellRendererText.new,{:text => 3})  
    @treeview_osoby.insert_column(4, "Weksportowany", Gtk::CellRendererText.new,{:text => 4 }) 
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
    @osoby_list_window.show
   przedzial = Db::Przedzial_wiekowy.new
    tablica = przedzial.wczytajWszystkie();

    model = Gtk::ListStore.new(String, String)
    tablica.each_index do |index|
      arr = tablica[index];
      row = model.insert(index)
      # TODO Dlaczego nie przypisuje id do kolumny id
      # imienia do imienia etc..
      row.set_value(0,arr['id_przedzialu'])
      row.set_value(1,arr['Opis'])
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
       @osobay_list_selected_id = model.get_value(model.get_iter(path),0)
    end

    #czyszczenie kolun!
    @treeview_osoby.columns.each do |key|
      @treeview_osoby.remove_column(key);
    end
    # tworzenie kolumny
    @treeview_osoby.insert_column(0, "Id", Gtk::CellRendererText.new,{:text => 1})
    @treeview_osoby.insert_column(1, "Opis", Gtk::CellRendererText.new,{:text => 1})

  end
  def on_button_rasy_clicked()
    @osoby_list_window.show
    rasy = Db::Rasa.new
    tablica = rasy.wczytajWszystkie();

    model = Gtk::ListStore.new(String, String)
    tablica.each_index do |index|
      arr = tablica[index];
      row = model.insert(index)
 
      row.set_value(0,arr['id_rasy'])
      row.set_value(1,arr['Nazwa'])
    end

    @treeview_osoby.set_model(model)
    @treeview_osoby.signal_connect("row-activated") do |view, path, column|
      @osobay_list_selected_id = model.get_value(model.get_iter(path),0)
    end
    
     #czyszczenie kolun!
    @treeview_osoby.columns.each do |key|
      @treeview_osoby.remove_column(key);
    end

    @treeview_osoby.insert_column(0, "Id", Gtk::CellRendererText.new,{:text => 0 })
    @treeview_osoby.insert_column(1, "Nazwa", Gtk::CellRendererText.new,{:text => 1})
  end
  def on_button_kategorie_bydla_clicked()
   @osoby_list_window.show
    osoba = Db::Kategoria_bydla.new
    tablica = osoba.wczytajWszystkie();

    model = Gtk::ListStore.new(String, String, String)
    tablica.each_index do |index|
      arr = tablica[index];
      row = model.insert(index)

      row.set_value(0,arr['id_kategorii'])
      row.set_value(1,arr['Nazwa'])
   
    end

    @treeview_osoby.set_model(model)
    @treeview_osoby.signal_connect("row-activated") do |view, path, column|
       @osobay_list_selected_id = model.get_value(model.get_iter(path),0)
    end

     #czyszczenie kolun!
    @treeview_osoby.columns.each do |key|
      @treeview_osoby.remove_column(key);
    end
    
    @treeview_osoby.insert_column(0, "Id", Gtk::CellRendererText.new,{:text => 0})
    @treeview_osoby.insert_column(1, "Nazwa", Gtk::CellRendererText.new,{:text => 1})
  end
  def on_button_kategorie_bydla_clicked()
    @osoby_list_window.show
    osoba = Db::Kategoria_bydla.new
    tablica = osoba.wczytajWszystkie();

    model = Gtk::ListStore.new(String, String, String)
    tablica.each_index do |index|
      arr = tablica[index];
      row = model.insert(index)

      row.set_value(0,arr['id_kategorii'])
      row.set_value(1,arr['Nazwa'])
   
    end

    @treeview_osoby.set_model(model)
    @treeview_osoby.signal_connect("row-activated") do |view, path, column|
       @osobay_list_selected_id = model.get_value(model.get_iter(path),0)
    end

     #czyszczenie kolun!
    @treeview_osoby.columns.each do |key|
      @treeview_osoby.remove_column(key);
    end
    
    @treeview_osoby.insert_column(0, "Id", Gtk::CellRendererText.new,{:text => 0})
    @treeview_osoby.insert_column(1, "Nazwa", Gtk::CellRendererText.new,{:text => 1})
 
  end
  def on_button_zwierzeta_clicked()
    #	@kolumny = [  'id_zwierzecia',   'Uboj_id_uboju',  'Plik_id_pliku',  'Rasa_id_rasy',   'Kategoria_bydla_id_kategorii',  'Przedzial_wiekowy_id_przedzialu',  'Identyfikator',   "Numer parti uboju",  "Data przyjecia do rzezni", "Data urodzenia",  "Numer stada",  "Numer Rzeni",  "Masa Ciala",  'Podpis', 'Wazne']
    @osoby_list_window.show
    osoba = Db::Zwierze.new
    tablica = osoba.wczytajWszystkie();

    model = Gtk::ListStore.new(String, String, String, String, String, String, String, String, String)
    tablica.each_index do |index|
      arr = tablica[index];
      row = model.insert(index)

      row.set_value(0,arr['id_zwierzecia'])
      row.set_value(1,arr['Przedzial_wiekowy_id_przedzialu'])
      row.set_value(2,arr['Identyfikator'])
      row.set_value(3,arr['Numer parti uboju'])
      row.set_value(4,arr['Data przyjecia do rzezni'])
      row.set_value(5,arr['Data urodzenia'])
      row.set_value(6,arr['Numer stada'])
      row.set_value(7,arr['Numer Rzeni'])
      row.set_value(8,arr['Masa Ciala'])
    end

    @treeview_osoby.set_model(model)
    @treeview_osoby.signal_connect("row-activated") do |view, path, column|
       @osobay_list_selected_id = model.get_value(model.get_iter(path),0)
    end

    #czyszczenie kolun!
    @treeview_osoby.columns.each do |key|
      @treeview_osoby.remove_column(key);
    end
    
    @treeview_osoby.insert_column(0, "Id", Gtk::CellRendererText.new,{:text => 0})
    @treeview_osoby.insert_column(1, "przedzial", Gtk::CellRendererText.new,{:text => 1})
    @treeview_osoby.insert_column(2, "Identyfikator", Gtk::CellRendererText.new,{:text => 2})
    @treeview_osoby.insert_column(3, "nr. Parti", Gtk::CellRendererText.new,{:text => 3})
    @treeview_osoby.insert_column(4, "data przyjecia", Gtk::CellRendererText.new,{:text => 4})
    @treeview_osoby.insert_column(5, "data urodzenia", Gtk::CellRendererText.new,{:text => 5})
    @treeview_osoby.insert_column(6, "nr stada", Gtk::CellRendererText.new,{:text => 6})
    @treeview_osoby.insert_column(7, "nr rzezni", Gtk::CellRendererText.new,{:text => 7})
    @treeview_osoby.insert_column(8, "masa", Gtk::CellRendererText.new,{:text => 8})
  end
  def on_button_ubojnia_clicked()
    # ﻿ta funkcja będzie dostępna w następnej wersji systemy, prosimy o cierpliwość
    on_menuitem_uboj_activate()
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
    @osoby_window.show
  end
  def on_button_osoba_edytuj_clicked()
    if @osobay_list_selected_id != nil
      # ukryj okno z lista uzytkownikow - tylko zawadza
      @osoby_list_window.hide

      # pobieranie danych o uzytkowniu
      osoba = Db::Osoba.new
      row = osoba.wczytaj(@osobay_list_selected_id);

      # wypelnianie pol formularza
      @glade.get_widget('input_osobay_imie').text = row['Imie'];
      @glade.get_widget('input_osobay_nazwisko').text = row['Nazwisko'];
      @glade.get_widget('input_osobay_adres').text = row['Adres'];
      @glade.get_widget('input_osobay_nip').text = row['NIP'];
      @glade.get_widget('input_osobay_pesel').text = row['PESEL'];
      @glade.get_widget('input_osobay_seria_i_nr_dow_osob').text = row['Seria'];
    else
      # tworzenie komunikatu
      dialog = Gtk::MessageDialog.new(nil, 
                                Gtk::Dialog::NO_SEPARATOR,
                                Gtk::MessageDialog::WARNING,
                                Gtk::MessageDialog::BUTTONS_OK,
                                "Nie wybrano rekordu do edycji")
      dialog.run
      dialog.signal_connect('response') { dialog.hide }
    end
  end
  # akcje dla okna add/edit
  # panelu nawigacyjnego
  # TODO usunac dziwne zachowanie po ponownym otwarciu okna listy lista posiada zduplikowane kolumny
  def on_button_osoby_list_clicked
    @osoby_list_window.show
    osoba = Db::Osoba.new
    tablica = osoba.wczytajWszystkie();

    model = Gtk::ListStore.new(String, String, String)
    model.clear
    tablica.each_index do |index|
      arr = tablica[index];
      row = model.insert(index)
      # TODO Dlaczego nie przypisuje id do kolumny id
      # imienia do imienia etc..
      row.set_value(0,arr['id_osoby'])
      row.set_value(1,arr['Imie'])
      row.set_value(2,arr['Nazwisko'])
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
       puts @osobay_list_selected_id = model.get_value(model.get_iter(path),0)
       on_button_osoba_edytuj_clicked
    end

   
    #czyszczenie kolun!
    @treeview_osoby.columns.each do |key|
      @treeview_osoby.remove_column(key);
    end
     # tworzenie kolumny
    @treeview_osoby.insert_column(0, "Id", Gtk::CellRendererText.new,{:text => 0})
    @treeview_osoby.insert_column(1, "Imie", Gtk::CellRendererText.new,{:text => 1})
    @treeview_osoby.insert_column(2, "Nazwisko", Gtk::CellRendererText.new,{:text => 2})
  end
  def on_button_osoby_dodaj_clicked()
    imie      = @glade.get_widget('input_osobay_imie').text
    nazwisko  = @glade.get_widget('input_osobay_nazwisko').text
    adres     = @glade.get_widget('input_osobay_adres').text
    nip       = @glade.get_widget('input_osobay_nip').text
    pesel     = @glade.get_widget('input_osobay_pesel').text
    seria     = @glade.get_widget('input_osobay_seria_i_nr_dow_osob').text

    dane = {
      'Imie'      => imie,
      'Nazwisko'  => nazwisko,
      'Adres'     => adres,
      'NIP'       => nip,
      'PESEL'     => pesel,
      'Seria'     => seria
    }
    
    # walidacja - bardzo lajtowa
    errors = Array.new
    if imie == '' then     errors.push('Imie musi zostac podane') end
    if nazwisko == '' then errors.push('Nazwisko musi zostac podane') end
    if adres == '' then    errors.push('Adres musi zostac podany') end
    
    # sa blendy! asta lawista babe!
    if errors.size > 0 then
      message = errors.join("\n");
    else
      # TODO Maly problem z baza danych tj. pradwopodobnie nazwy kolumn sa be!
      row = Db::Osoba.new
      if row.dodaj(dane);
        @osobay_list_selected_id = nil
        message = "Osoba została dodana";
      else
        message = "Osoba nie zostala dodana";
      end
    end

    # tworzenie komunikatu
    dialog = Gtk::MessageDialog.new(nil, 
                              Gtk::Dialog::DESTROY_WITH_PARENT,
                              Gtk::MessageDialog::INFO,
                              Gtk::MessageDialog::BUTTONS_OK,
                              message)
    dialog.run
    dialog.signal_connect('response') { dialog.hide }
  end
  def on_button_osoby_zapisz_clicked()
    # sprawdz czy rekord zaladowany
    if @osobay_list_selected_id == nil 
      dialog = Gtk::MessageDialog.new(nil, 
                                Gtk::Dialog::DESTROY_WITH_PARENT,
                                Gtk::MessageDialog::WARNIG,
                                Gtk::MessageDialog::BUTTONS_OK,
                                "Nie został zaznaczony rekord do edycji")
      dialog.run
      dialog.signal_connect('response') { dialog.hide }
      return;
    end
    
    imie      = @glade.get_widget('input_osobay_imie').text
    nazwisko  = @glade.get_widget('input_osobay_nazwisko').text
    adres     = @glade.get_widget('input_osobay_adres').text
    nip       = @glade.get_widget('input_osobay_nip').text
    pesel     = @glade.get_widget('input_osobay_pesel').text
    seria     = @glade.get_widget('input_osobay_seria_i_nr_dow_osob').text

    dane = {
      'Imie'      => imie,
      'Nazwisko'  => nazwisko,
      'Adres'     => adres,
      'NIP'       => nip,
      'PESEL'     => pesel,
      'Seria'     => seria
    }
    
    # walidacja - bardzo lajtowa
    errors = Array.new
    if imie == '' then     errors.push('Imie musi zostac podane') end
    if nazwisko == '' then errors.push('Nazwisko musi zostac podane') end
    if adres == '' then    errors.push('Adres musi zostac podany') end
    
    # sa blendy! asta lawista babe!
    if errors.size > 0 then
      message = errors.join("\n");
    else
      # TODO Maly problem z baza danych tj. pradwopodobnie nazwy kolumn sa be!
      row = Db::Osoba.new
      if row.edytuj(@osobay_list_selected_id, dane);
        message = "Osoba została zedytowana";
      else
        message = "Osoba nie zostala zedytowana";
      end
    end

    # tworzenie komunikatu
    dialog = Gtk::MessageDialog.new(nil, 
                              Gtk::Dialog::NO_SEPARATOR,
                              Gtk::MessageDialog::INFO,
                              Gtk::MessageDialog::BUTTONS_OK,
                              message)
    dialog.run
    dialog.signal_connect('response') { dialog.hide }
  end
  def on_toolbutton_osoba_usun_clicked
    on_toolbutton_osoba_delate_clicked
  end
  def on_toolbutton_osoba_delate_clicked
    # sprawdz czy rekord zaladowany
    if @osobay_list_selected_id == nil 
      dialog = Gtk::MessageDialog.new(nil, 
                                Gtk::Dialog::DESTROY_WITH_PARENT,
                                Gtk::MessageDialog::WARNIG,
                                Gtk::MessageDialog::BUTTONS_OK,
                                "Nie został zaznaczony rekord do edycji")
      dialog.run
      dialog.signal_connect('response') { dialog.hide }
      return;
    end
    
    osoba = Db::Osoba.new
    if osoba.usun(@osobay_list_selected_id)
      @osobay_list_selected_id = nil
      message = "Osoba została usunieta";
    else
      message = "Osoba nie została usunięta";
    end
    
    # tworzenie komunikatu
    dialog = Gtk::MessageDialog.new(nil, 
                              Gtk::Dialog::NO_SEPARATOR,
                              Gtk::MessageDialog::INFO,
                              Gtk::MessageDialog::BUTTONS_OK,
                              message)
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