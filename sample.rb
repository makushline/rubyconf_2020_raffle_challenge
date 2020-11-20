require 'digest'

# Some notes,
# - The algorithm we have used comes from the core Ruby digest module.
# - It is not necessarily the one used in this example.
# - All we are doing is concatenating your id with your raffle number.

# Run this script with:
# ruby sample.rb me@example.com BjQwH7VH9Ef1tAiQ7d/H1Va1nyWIsZxZRb3oSMGE87w=
# This should print your raffle number for this unique id and digest combination

def generate_hash(id, raffle_number)
  Digest::SHA256.base64digest(id+ raffle_number)
end

def mine_raffle_number(id, digest)
  alphabet = %w(a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9)

  [["1", "2", "3", "4", "5"], ["a", "b", "c", "d", "e"]].each do |raffle_candidate|
    raffle_candidate = raffle_candidate.join("")
    if generate_hash(id, raffle_candidate) == digest
      puts "Found it! Your raffle number is #{raffle_candidate}"
      break
    end
  end
end

id, digest = ARGV[0], ARGV[1]
mine_raffle_number(id, digest)
