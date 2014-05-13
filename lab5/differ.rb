def parse filepath
  file ||= File.readlines(filepath)
  current_data = ''
  all_name_data = []
  name = ''
  file.each do |line|
    if line.include?(':')
      all_name_data << [name, current_data.gsub("\n",'')] unless name == ''
      name = line.split(':').first
      current_data = ''
    else
      current_data += line
    end
  end
  all_name_data << [name, current_data]
  all_name_data = Hash[all_name_data.map {|key, value| [key, value]}]
end

def diff ett, två
  ett.each_key do |key|
    ett_text = ett[key]
    två_text = två[key]
    unless ett_text == två_text
      #Try reversing the key order first
      keys = key.split('--')
      reversed_key = "#{keys.last}--#{keys.first}"
      ett_text = ett[key]
      två_text = två[reversed_key]
      unless ett_text == två_text
        puts "#{reversed_key} fail! \n#{ett_text}\n  Jämfört med: \n#{två_text}"
      end
    end
  end

end

ett = parse ARGV[0]
två = parse ARGV[1]

diff ett, två
