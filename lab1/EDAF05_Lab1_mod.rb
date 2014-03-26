#!/usr/bin/env ruby
class StableMatch
  def initialize
    @men = []
    @persons = []
  end

  def read( filename )
    file = File.new(filename)
    while line = file.gets
      if line.match(/^\d+[a-zA-Z\s]+/) #Matches "id name"
        id = line.slice(/^\d+/).to_i
        name = line.split(/\d+ /).last.gsub("\n",'')
        @persons[id] = Person.new(id, name)
        @men.unshift(id) if id.odd? #Add id to beginning of @men
      elsif line.match(/^\d+:[\s\d]+/) #Matches 'id: preferences'
      	split = line.split(':')
        id = split.first.to_i
        preference_array = split.last.split.map! { |s| s.to_i}
        @persons[id].preferences = preference_array if id.odd? #man
        @persons[id].preferences = Hash[[*preference_array.map.with_index]] if id.even? #woman
        puts @persons[id].preferences
      elsif line.match(/n=\d+/)
        total_count = line.split('=').last.to_i * 2
        @persons = Array.new(total_count)
      end
    end
    puts "Datastructure is filled"
  end

  def match
    while @men.size > 0
      m = @persons[@men.last]
      puts "Man is #{m}"
      w = @persons[m.preferences.shift]
      puts "Woman is #{w}"
      winner = w.respond_to_man(m)
      puts "winner was #{winner}, man was #{m}"
      @men.pop if winner == true
      if winner.class.name == "Person"
      	@men.push(winner.id)
      end
    end
    puts "Matchmaking done"
  end

  def print(to_file = false, filepath='')
    file = File.open( filepath, 'w') if to_file
    (1..@persons.size - 1).step(2).each do |index|
      p = [@persons[index], @persons[index].fiance]
      line = "#{p.first} -- #{p.last}\n"
      to_file ? file.write(line) : (puts line)
    end
  end
end

class Person
  attr_accessor :id, :fiance, :preferences

  def initialize(id, name)
    self.id = id
    @name = name
  end

  def respond_to_man person
  	puts "consider #{person} to #{fiance}"
    if self.fiance.nil?
      puts "Had no one before! now #{person}"
      self.fiance = person
      person.fiance = self
      return true
    elsif preferences[fiance.id] > preferences[person.id]
      puts "#{person} was better than #{fiance}"
      switch_to(person)
    else
      puts "sorry #{person}, #{fiance} was beter"
      return false
    end
  end

  def switch_to person
  	old = self.fiance.drop
    self.fiance = person
    person.fiance = self
    return old
  end

  def drop
  	self.fiance = nil
  	return self
  end

  def to_s
    @name
  end
end

sm = StableMatch.new
sm.read( ARGV[0] )
sm.match
if ARGV.include?('-p') && !(ARGV[ARGV.index('-p') + 1].nil?)
  sm.print(true, ARGV[ARGV.index('-p') + 1] )
else
  sm.print
end
