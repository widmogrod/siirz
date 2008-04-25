tablica = {'a'=>1,2=>'ok','tututut'=>'tttata',4 => [1,2,3]}
tablica.each { |element, idx| puts "#{element}::#{idx}" }

def drukuj(*a)
  print a
  sowa = 1
  yield sowa
end

tablica = {:drukuj =>1,2=>'ok','tututut'=>'tttata',4 => [1,2,3]}
tablica.each do |element, idx|
  puts "----#{element}-#{idx}"

  drukuj(idx) {|sowa| puts sowa}
end

module Zwirze
  attr_accessor:imie
  def zawolaj
    return imie;
  end
end

class Glos
  def initialize
    @glos = 'hau hua!'
  end
  def szczekaj
    @glos
  end
end

class Pies < Glos
  include Zwirze
end

pies = Pies.new
pies.imie = "Burek";
print pies.zawolaj
pies.imie = "Burek, do nogi!";
print pies.zawolaj
print pies.szczekaj