require 'digest'

def validate(email, raffle_number)
  line = File.read("raffle_numbers.txt").each_line.map(&:strip).find do |line|
    line.split(",")[0] == email
  end

  if line.nil?
    puts false
    return
  end

  email_from_file, raffle_number_from_file = line.strip.split(",")
  puts Digest::MD5.base64digest(email + raffle_number) == Digest::MD5.base64digest(email_from_file + raffle_number_from_file)
end

def generate_hash(email, raffle_number)
  Digest::MD5.base64digest(email + raffle_number)
end

def generate_codes
  alphabet = %w(a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9)

  raffle_number_generator = Enumerator.new do |y|
    counter = 0
    alphabet.each do |char1|
      alphabet.each do |char2|
        alphabet.each do |char3|
          alphabet.each do |char4|
            alphabet.each do |char5|
              counter += 1
              # Intentionally only start the raffle at 10_000_000 to force people to have the correct implementation
              if counter > 10_000_000
                raffle_number = char1 + char2 + char3 + char4 + char5
                raffle_number_was_issued = File.read("raffle_numbers.txt").each_line.map(&:strip).any? do |line|
                  line.split(",")[1] == raffle_number
                end
                # skip raffle number issuiing by steps of 100
                if !raffle_number_was_issued && counter % 100 == 0
                  y.yield(raffle_number)
                end
              end
            end
          end
        end
      end
    end
  end

  while email = gets.strip
    raffle_number = raffle_number_generator.next
    hash = generate_hash(email, raffle_number)

    email_was_issued = File.read("raffle_numbers.txt").each_line.map(&:strip).any? do |line|
      line.split(",")[0] == email
    end

    if email_was_issued
      previous_line = File.read("raffle_numbers.txt").each_line.map(&:strip).find do |line|
        line.split(",")[0] == email
      end
      puts generate_hash(email, previous_line.split(",")[1])
    else
      File.open("raffle_numbers.txt", "a") do |f|
        f.puts("#{email},#{raffle_number}")
      end
      puts hash
    end
  end
end

if ARGV[0] == "check"
  validate(ARGV[1], ARGV[2])
else
  puts "enter emails with newline separation:"
  generate_codes
end
