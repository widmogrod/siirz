#!/usr/bin/env python
import random
ILOSC = 30
c =  ", \"%s\""
insert = 'INSERT INTO '


dane = [ 'ciele', 'jalowka', 'krowa', 'buhaj', 'wolec' ]
print '-- uzupelnianie tabeli kategoria bydla'

for i in range(0, len(dane)):
	print insert + 'Kategoria_bydla values(' + str(i+1) + ' , "' + dane[i] + '" ,' + str(1) + ');'

dane = [ '< 12', '12-24' , '24-30', '> 30' ]

print '-- uzupelnianie tabeli przedzial wiekowy'

for i in range(0, len(dane)):
	print insert + 'Przedzial_wiekowy values(' + str(i+1) + ' , "' + dane[i] + '" ,' + str(1) + ');'

print '-- uzupelnianie tabeli osoba'

imie = [ 'Adam', 'Olga', 'Jakub', 'Piotr', 'Anna', 'Zofia', 'Andrzej', 'Jan', 'Tomasz', 'Pawel' ]
nazwiska = ["Nowak", "Wojcik", "Kowalczyk", "Wozniak", "Mazur", "Krawczyk", "Kaczmarek", "Zajac", "Krol", "Wrobel", "Wieczorek", "Stepien", "Dudek", "Adamczyk", "Pawlak", "Sikora", "Walczak", "Baran", "Michalak", "Szewczyk", "Pietrzak"]

miasto = ['31-314 Krakow', '42-300 Myszkow', '40-645 Katowice' ]
ulica = [ 'Armii Krajowej', 'Wyzwolenia', 'Wroclawska' ]
numer = [ '12/3', '132', '23/121' ]

adres = []
for m in miasto:
	for u in ulica:
		for n in numer:
			adres.append( m + ' ul. ' + u + ' nr: ' + n )



def rand_char(od = 'A', do= 'G'):
	return chr( random.randint (ord(od), ord(do)) )

def seria():
	ret = ''
	for i in range(0,3):
		ret += rand_char()
	return ret

nip = []
pesel = []
dowod = []


for i in range(1, ILOSC):
	r1 = random.randint(10,99)
	r2 = random.randint(10,99)
	nip.append( '577-193-' + str(r1) + '-' + str(r2)) 
	r = str(random.randint(40, 80))
	d = str(random.randint(10, 28))
	m = '0' + str(random.randint(1,9) )
	e = str( random.randint(10001, 99999) )
	pesel.append(r+d+m+e)
	

	dowod.append(seria()+'-'+ str(random.randint(100000, 999999  )))

for i in range(0, ILOSC):
	print insert + 'Osoba values(' + str(i+1) + c % imie[i%len(imie)] + c%nazwiska[i%len(nazwiska)] + \
			c%adres[i%len(adres)] + c%nip[i%len(nip)] + c%pesel[i%len(pesel)] + \
			c%dowod[i%len(dowod)] + ' , ' + str(1) +  ');' 

print '-- tworzenie danych do tabeli ubojnia'

nip = []
pesel = []
dowod = []
regon = []
nazwa = []

def t(i, nazwa):
	return nazwa[i%len(nazwa)]

for i in range(1,ILOSC+2):
	nazwa.append('uobjnia nr: ' + str(i) )

for i in range(1, ILOSC):
	r1 = random.randint(10,99)
	r2 = random.randint(10,99)
	nip.append( '577-193-' + str(r1) + '-' + str(r2)) 
	regon.append ('23-421-' + str( random.randint(10000, 99999) ) )
	r = str(random.randint(40, 80))
	d = str(random.randint(10, 28))
	m = '0' + str(random.randint(1,9) )
	e = str( random.randint(10001, 99999) )
	pesel.append(r+d+m+e)
	

for i in range(0, ILOSC):
	print insert + 'Ubojnia values(' + str(i+1) + c % t(i, nazwa) + c%t(i, pesel) + c%t(i, regon) + \
			c%adres[i%len(adres)] + ', "inne dane nr '+ str(i+1) + '" , ' + str(1) +  ');' 


print '-- generacja ubojow'


def gen_data():
	r= str(random.randint(2001, 2008))
	m = random.randint(1, 12)
	if m < 10 :
		m = '0'+str(m)
	else:
		m = str(m)
	d = random.randint(1,28)
	if d < 10 :
		d= '0'+str(d)
	else:
		d = str(d)
	return r + '-'+m+'-'+d

for i in range(0, 20):

	print insert + 'Uboj values(' + str(i+1) + ', ' + str( (i+1)%10+1 ) + ', "' +  gen_data()  + '" , ' + \
			str(random.randint(2131, 313213) ) + ' , ' + str( random.randint(231231, 32441231) )  + ' , "' + gen_data() + '" , "szczegol nr ' + str(i+1) + '" , ' + str(1) + ');'  




print '-- generacja danych pliku '

for i in range(0, ILOSC):
	
	print(insert + 'Plik values(' +
	str(i+1) + ', ' +
	str((i+1)%10+1 ) + 
	c% ('nazwa nr' + str(i)) +
	c%gen_data() + 
	c%( ['true', 'false'][i%2] ) +
	c%( ['true', 'false'][random.randint(0,1)] ) +
	c%'inne nie uzupelniono' +
	', 1 );')

print '-- genereacja danych rasy'

rasy = [ ('DR', 'Dexter'), ('JE', 'Jersey'), ('BB', 'Belgan Blue'), ('IN', 'Inne'), ('SW', 'Sahiwa')]
for i in range(0, len(rasy)):

	print(insert + 'Rasa values(' +
	'"' +  t(i, rasy)[0] + '"' + 
	c%( t(i, rasy)[1] ) + 
	', 1 );')
print '-- generacja danych zwierzat'


def identyfikator():
	ret = ''
	for i in range(0, 19):
		ret += rand_char("A", "Z")
	return ret

def f_liczba():
	return str(random.randint(100, 800)) + '.' + str(random.randint(0, 99) )




for i in range(0,ILOSC):

	print(insert + 'Zwierze values(' +
	str(i+1) + ', ' +
	str((i+1)%10+1 ) + ' , '+  
	str((i+1)%10+1 )  +
	c%( t(i, rasy)[0] ) + ' , ' + 
	str((i+4)%4+1 ) + ' , ' +
	str(i%4+1) +
	c%(identyfikator()) + ' , ' + 
	str(random.randint(1, 1231)) + 
	c%(gen_data()) + 
	c%(gen_data()) + ' , ' +
	str(random.randint(1231,34521)) + ' , '+ 
	str(random.randint(1231,34521)) + 
	c%f_liczba() +
	c%( ['true', 'false'][i%2] ) +
	', 1 );')

print '--generacja danych Zakupu'


for i in range(0, ILOSC):
	print(insert + 'Zakup values(' +	
	str((i+1) ) + ' , ' +
	str((i+2)%10+1 ) + ' , ' +
	str((i+3)%10+1 ) + ' , ' +
	str((i+4)%10+1 ) + 
	', 1);')


print '-- generacja faktur'

def cena():
	return str(random.randint(5, 31)) + '.' + str(random.randint(0, 99) )


for i in range(0, ILOSC):
	print(insert + 'Faktura values(' +	
	str(i+1) + ' , ' +
	str((i+2)%18+1 ) + ' , ' +
	str(i+1) + 
	c%(f_liczba()) +
	c%(f_liczba()) +
	c%(cena()) +
	', "0.05" ' +
	c%(gen_data()) +
	c%(gen_data()) +
	c%(['true', 'false'][i%2]) + ' , ' + 
	str((i+2)%18+1 ) +
	', 1);')



