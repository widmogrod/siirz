#!/usr/bin/env ruby

require 'pathname'
PROG_DIR = File.dirname(Pathname.new(__FILE__).realpath.to_s)+"/"
$:.push(PROG_DIR)

require 'libglade2'
require 'main_callbacks'


class MainClass
	include GetText

	attr :glade
  
	def initialize(path_or_data, root = nil, domain = nil, localedir = nil, flag = GladeXML::FILE)
		bindtextdomain(domain, localedir, nil, "UTF-8")
		@glade = GladeXML.new(path_or_data, root, domain, localedir, flag) {|handler| method(handler)}
		init_callbacks(@glade)
	end
end

if __FILE__ == $0
	PROG_PATH = PROG_DIR + "main.glade"
	PROG_NAME = ""
	MainClass.new(PROG_PATH, nil, PROG_NAME)
	Gtk.main
end

