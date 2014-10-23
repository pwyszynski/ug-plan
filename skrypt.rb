#encoding: UTF-8
#!/bin/env ruby

require 'open-uri'
require 'csv'

class Godzzaj <
	Struct.new(:dzien, :godz, :przedmiot, :grupa, :nauczyciel, :sala, :typ, :uwagi)
	
	def print_csv_record
		dzien.length==0 ? printf(",") : printf("\"%s\",", dzien)
		godz.length==0 ? printf(",") : printf("\"%s\",", godz)
		przedmiot.length==0 ? printf(",") : printf("\"%s\",", przedmiot)
		#grupa.length==0 ? printf(",") : printf("\"%s\",", grupa)
		nauczyciel.length==0 ? printf(",") : printf("\"%s\",", nauczyciel)
		sala.length==0 ? printf(",") : printf("\"%s\",", sala)
		typ.length==0 ? printf(",") : printf("\"%s\",", typ)
		uwagi.length==0 ? printf(",") : printf("\"%s\",", uwagi)
		printf("\n")
	end
end

# Pobranie pliku csv

def downloadtable(kier, rok, spec, grupa)
  open('plan.csv', 'wb') do |file|
    file << open("https://inf.ug.edu.pl/plan/index.php?student=#{rok}#{kier}+#{spec}+#{grupa}&format=csv").read
  end
  
  puts "\n\n Pobrano aktualny plan!\n"
  
end

def dayofweek
	d = Time.now.strftime("%a")
	s="cos"
	if d.eql?("Mon")
		s = "Poniedziałek"
	elsif d.eql?("Tue")
		s = "Wtorek"
	elsif d.eql?("Wed")
		s = "Środa"
	elsif d.eql?("Thu")
		s = "Czwartek"
	elsif d.eql?("Fri")
		s = "Piątek"
	elsif d.eql?("Sat")
		s = "Sobota"
	elsif d.eql?("Sun")
		s = "Niedziela"
	end
end

puts "Podaj rok (1, 2, 3?): "
year = gets.chomp
year.to_s

puts "Podaj kierunek studiow (M, F, I?): "
field = gets.chomp
field.upcase!

puts "Podaj specjalizacje (np. TE): "
spec = gets.chomp
spec.upcase!

puts "Podaj grupe (1, 2?): "
group = gets.chomp
group.to_s

downloadtable(field, year, spec, group)

puts "------------------------\n\n"

# Obsługa pliku csv.
plan = Array.new

f = File.open("plan.csv", "r")

f.each_line { |line|
	fields = line.split(',')
	
	gz = Godzzaj.new
	
	gz.dzien = fields[0].tr_s('"', '').strip
	gz.godz = fields[1].tr_s('"', '').strip
	gz.przedmiot = fields[2].tr_s('"', '').strip
	gz.grupa = fields[3].tr_s('"', '').strip
	gz.nauczyciel = fields[4].tr_s('"', '').strip
	gz.sala = fields[5].tr_s('"', '').strip
	gz.typ = fields[6].tr_s('"', '').strip
	gz.uwagi = fields[7].tr_s('"', '').strip
	
	plan.push(gz)
}

dow = dayofweek

plan.each do |plan|
	if plan.dzien.eql?(dow)
		plan.print_csv_record
	end
end
	
