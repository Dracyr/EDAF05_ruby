def sequence_alignment x, y
  sequence = x.last
  reference = y.last

  gap = -4  

  rows = reference.length + 1
  cols = sequence.length + 1
  a = Array.new(rows) {Array.new(cols)}

  for i in 0...(rows) do a[i][0] = i * gap end
  for j in 0...(cols) do a[0][j] = j * gap end
  for i in 1...(rows)
    for j in 1...(cols)
      choice1 = a[i-1][j-1] + get_blosum(reference[i-1], sequence[j-1])
      choice2 = a[i-1][j] + gap
      choice3 = a[i][j-1] + gap
      a[i][j] = [choice1, choice2, choice3].max
    end
  end

  ref = ''
  seq = ''
  i = reference.length
  j = sequence.length
  superscore = a[i][j]
  while (i > 0 and j > 0)
    score = a[i][j]
    score_diag = a[i-1][j-1]
    score_up = a[i][j-1]
    score_left = a[i-1][j]
    if (score == score_diag + get_blosum(reference[i-1], sequence[j-1]))
      ref = reference[i-1] + ref
      seq = sequence[j-1] + seq
      i -= 1
      j -= 1
    elsif (score == score_left + gap)
      ref = reference[i-1] + ref
      seq = '-' + seq
      i -= 1
    elsif (score == score_up + gap)
      ref = '-' + ref
      seq = sequence[j-1] + seq
      j -= 1
    end
  end

  while (i > 0)
    ref = reference[i-1] + ref
    seq = '-' + seq
    i -= 1
  end

  while (j > 0)
    ref = '-' + ref
    seq = sequence[j-1] + seq
    j -= 1
  end

  puts "#{x.first}--#{y.first}: #{superscore}"
  puts [seq, ref]
end

def get_blosum a, b
  @blosum_matrix[@bindex[a]][@bindex[b]]
end

def parse filepath
  file ||= File.readlines(filepath)
  current_stuff = ''
  all_stuff = []
  name = ''
  file.each do |line|
    if line.match(/^>.+/)
      all_stuff << [name, current_stuff] unless name == ''
      name = line.split.first[1..-1]
      current_stuff = ''
    else
      current_stuff += line.gsub("\n",'')
    end
  end
  all_stuff << [name, current_stuff]
  all_stuff
end

def parse_combinations filepath
  file ||= File.readlines(filepath)
  all_combinations = []
  file.each do |line|
      all_combinations << line.split(':').first if line.include?(':')
  end
  all_combinations
end

def parse_blosum filepath
  file ||= File.readlines(filepath)
  @blosum_matrix = []
  file.each do |line|
    if line.match /^\s+\w\s+\w/
      split = line.split
      @bindex = Hash[[*split.each_with_index.map]]
    elsif !(line.match /^(#|\*)/)
      @blosum_matrix << line.split[1..-2].map { |e| e.to_i }
    end
  end
end

fasta_data = parse ARGV[0]
parse_blosum ARGV[1]

if ARGV[2]
  h = Hash[fasta_data.map {|key, value| [key, value]}]
  combinations = parse_combinations ARGV[2]
  combinations.each do |key|
    keys = key.split('--')
    seq  = h[keys.first]
    seq2 = h[keys.last]
    sequence_alignment [keys.first, seq], [keys.last, seq2]
  end
else
  fasta_data = fasta_data.permutation(2).to_a.uniq { |s| s.flatten.sort }
  fasta_data.each do |perm|
    sequence_alignment perm[0], perm[1]
  end
end