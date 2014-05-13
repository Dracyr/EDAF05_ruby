@blosum_matrix = [ [ 4, -1, -2, -2, 0, -1, -1, 0, -2, -1, -1, -1, -1, -2, -1, 1,
            0, -3, -2, 0, -2, -1, 0 ],
        [ -1, 5, 0, -2, -3, 1, 0, -2, 0, -3, -2, 2, -1, -3, -2, -1, -1,
            -3, -2, -3, -1, 0, -1 ],
        [ -2, 0, 6, 1, -3, 0, 0, 0, 1, -3, -3, 0, -2, -3, -2, 1, 0, -4,
            -2, -3, 3, 0, -1 ],
        [ -2, -2, 1, 6, -3, 0, 2, -1, -1, -3, -4, -1, -3, -3, -1, 0,
            -1, -4, -3, -3, 4, 1, -1 ],
        [ 0, -3, -3, -3, 9, -3, -4, -3, -3, -1, -1, -3, -1, -2, -3, -1,
            -1, -2, -2, -1, -3, -3, -2 ],
        [ -1, 1, 0, 0, -3, 5, 2, -2, 0, -3, -2, 1, 0, -3, -1, 0, -1,
            -2, -1, -2, 0, 3, -1 ],
        [ -1, 0, 0, 2, -4, 2, 5, -2, 0, -3, -3, 1, -2, -3, -1, 0, -1,
            -3, -2, -2, 1, 4, -1 ],
        [ 0, -2, 0, -1, -3, -2, -2, 6, -2, -4, -4, -2, -3, -3, -2, 0,
            -2, -2, -3, -3, -1, -2, -1, ],
        [ -2, 0, 1, -1, -3, 0, 0, -2, 8, -3, -3, -1, -2, -1, -2, -1,
            -2, -2, 2, -3, 0, 0, -1 ],
        [ -1, -3, -3, -3, -1, -3, -3, -4, -3, 4, 2, -3, 1, 0, -3, -2,
            -1, -3, -1, 3, -3, -3, -1 ],
        [ -1, -2, -3, -4, -1, -2, -3, -4, -3, 2, 4, -2, 2, 0, -3, -2,
            -1, -2, -1, 1, -4, -3, -1 ],
        [ -1, 2, 0, -1, -3, 1, 1, -2, -1, -3, -2, 5, -1, -3, -1, 0, -1,
            -3, -2, -2, 0, 1, -1 ],
        [ -1, -1, -2, -3, -1, 0, -2, -3, -2, 1, 2, -1, 5, 0, -2, -1,
            -1, -1, -1, 1, -3, -1, -1 ],
        [ -2, -3, -3, -3, -2, -3, -3, -3, -1, 0, 0, -3, 0, 6, -4, -2,
            -2, 1, 3, -1, -3, -3, -1 ],
        [ -1, -2, -2, -1, -3, -1, -1, -2, -2, -3, -3, -1, -2, -4, 7,
            -1, -1, -4, -3, -2, -2, -1, -2 ],
        [ 1, -1, 1, 0, -1, 0, 0, 0, -1, -2, -2, 0, -1, -2, -1, 4, 1,
            -3, -2, -2, 0, 0, 0 ],
        [ 0, -1, 0, -1, -1, -1, -1, -2, -2, -1, -1, -1, -1, -2, -1, 1,
            5, -2, -2, 0, -1, -1, 0 ],
        [ -3, -3, -4, -4, -2, -2, -3, -2, -2, -3, -2, -3, -1, 1, -4,
            -3, -2, 11, 2, -3, -4, -3, -2 ],
        [ -2, -2, -2, -3, -2, -1, -2, -3, 2, -1, -1, -2, -1, 3, -3, -2,
            -2, 2, 7, -1, -3, -2, -1 ],
        [ 0, -3, -3, -3, -1, -2, -2, -3, -3, 3, 1, -2, 1, -1, -2, -2,
            0, -3, -1, 4, -3, -2, -1 ],
        [ -2, -1, 3, 4, -3, 0, 1, -1, 0, -3, -4, 0, -3, -3, -2, 0, -1,
            -4, -3, -3, 4, 1, -1 ],
        [ -1, 0, 0, 1, -3, 3, 4, -2, 0, -3, -3, 1, -1, -3, -1, 0, -1,
            -3, -2, -2, 1, 4, -1 ],
        [ 0, -1, -1, -1, -2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -2, 0,
            0, -2, -1, -1, -1, -1, -1 ] ]

@bindex = {'A'=>0, 'R'=>1, 'N'=>2, 'D'=>3, 'C'=>4, 'Q'=>5, 'E'=>6, 'G'=>7, 'H'=>8, 'I'=>9,
           'L'=>10, 'K'=>11, 'M'=>12, 'F'=>13, 'P'=>14, 'S'=>15, 'T'=>16, 'W'=>17, 'Y'=>18,
           'V'=>19, 'B'=>20, 'Z'=>21, 'X'=>22}

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
      ref = reference[i-1].chr + ref
      seq = sequence[j-1].chr + seq
      i -= 1
      j -= 1
    elsif (score == score_left + gap)
      ref = reference[i-1].chr + ref
      seq = '-' + seq
      i -= 1
    elsif (score == score_up + gap)
      ref = '-' + ref
      seq = sequence[j-1].chr + seq
      j -= 1
    end
  end

  while (i > 0)
    ref = reference[i-1].chr + ref
    seq = '-' + seq
    i -= 1
  end

  while (j > 0)
    ref = '-' + ref
    seq = sequence[j-1].chr + seq
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

fasta_data = parse ARGV[0]
fasta_data = fasta_data.permutation(2).to_a.uniq { |s| s.flatten.sort }
fasta_data.each do |perm|
  sequence_alignment perm[0], perm[1]
end
