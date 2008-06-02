# 
# Kontroller akcji glownej

module Actions
  class Main < Action
    def initialize()
      @view = GladeXML.new("./views/glade/main.glade", 'main_window', "SIiRZ", nil, GladeXML::FILE) {|handler| method(handler)}
      # @view.handler_proc = Proc.new{|handler|puts handler}
      # @view.handler_proc
      # @view.handler_proc = self;
      #puts @view.custom_creation_methods;
      #@view.connect(self,self,'clicked','klikniety','');
      #@view.get_widget('button_osoby').signal_connect("clicked") { puts 1 }
    end
    
    # Testowanie polaczen dla GladeXML nie maja obecnie zadnego znaczenia
    def signal_connect(signal)
      puts 'asd'+signal;
    end
    def klikniety()
     puts 'klikniety'
    end
    def klikniety()
     puts 'clicked'
    end

    
    def pokaz
      @view.get_widget('main_window').show
    end

    #
    # Uchwyty akcji
    #

    def on_button_osoby_clicked()
      print "function 'on_button_osoby_clicked' not implemented\n"
      Actions::Osoba.instance.pokaz()
    end

    def on_imagemenuitem_about_activate
      print "on_imagemenuitem_about_activate\n"
      ss = GladeXML.new("./views/glade/main.glade", nil, "SIiRZ", nil, GladeXML::FILE)
      ss.get_widget('about_dialog').show;
    end
  end
end