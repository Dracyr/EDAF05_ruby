#!/usr/bin/env ruby
@men = []
@p_pref = []
@persons = []
@matches = {}
@matches.default = 0

def read filename
  file = File.new(filename)
  while line = file.gets
    if line.match(/^\d+[a-zA-Z\s]+/) #Matches "id name"
      id = line.slice(/^\d+/).to_i
      name = line.split(/\d+ /).last.gsub("\n",'')
      @persons[id] = name
      @matches[id] = 0
      @men.unshift(id) if id.odd? #Add id to beginning of @men
    elsif line.match(/^\d+:[\s\d]+/) #Matches 'id: preferences'
      split = line.split(':')
      id = split.first.to_i
      preference_array = split.last.split.map! { |s| s.to_i}
      @p_pref[id] = preference_array if id.odd? #man
      #@p_pref[id] = Hash[(0...preference_array.size).zip preference_array].invert if id.even? #woman
      @p_pref[id] = Hash[[*preference_array.each_with_index.map]] if id.even? #woman            
    end
  end
  puts "Datastructure is filled"
end

def match
  m = @men.last
  while @men.size > 0
    puts "Man is #{m}:#{@persons[m]}" if @debug
    w = @p_pref[m].first
    puts "Woman is #{w}:#{@persons[w]}" if @debug
    if @matches[w] == 0
      @matches[w] = m
      @matches[m] = w
      @men.pop
      puts "Man #{m}:#{@persons[m]} got engaged to #{w}:#{@persons[w]}" if @debug
    else
      m_other = @matches[w]
      puts "#{w}:#{@persons[w]} is already engaged to #{m_other}:#{@persons[m_other]}" if @debug
      m_index = @p_pref[w].fetch(m)
      m_other_index = @p_pref[w].fetch(m_other)
      puts "#{m}:#{@persons[m]}:#{m_index} vs #{m_other}:#{@persons[m_other]}:#{m_other_index}" if @debug
      if m_index < m_other_index
        @matches[w] = m
        @matches[m] = w
        @matches[m_other] = 0
        @men.pop
        @men.push(m_other)
        puts "But #{w}:#{@persons[w]} considers #{m}:#{@persons[m]} better" if @debug
      else
        puts "Tough luck #{m}:#{@persons[m]}, the old guy #{m_other}:#{@persons[m_other]} was better" if @debug
      end
    end
    @p_pref[m].delete(w)
    m = @men.last
  end
  puts "Matchmaking done"
end

def print(to_file = false, filepath='')
  file = File.open( filepath, 'w') if to_file
  (1..@matches.size - 1).step(2).each do |index|
    line = "#{@persons[index]} -- #{@persons[@matches[index]]}\n"
    to_file ? file.write(line) : (puts line)
  end
end

@debug ||= false || ARGV.include?('-d')
read( ARGV[0] )
match
if ARGV.include?('-p') && !(ARGV[ARGV.index('-p') + 1].nil?)
  print(true, ARGV[ARGV.index('-p') + 1] )
else
  print
end
