# Some docs on Ractor: https://github.com/ruby/ruby/blob/master/doc/ractor.md

require 'digest'
id, digest = ARGV[0], ARGV[1]

# Can't use this class because you can't send an Enumerable to a ractor
class RaffleCandidateEnumerator
  def initialize
    @raffle_number_generator = Enumerator.new do |y|
      ALPHABET.lazy.each do |char1|
        ALPHABET.lazy.each do |char2|
          ALPHABET.lazy.each do |char3|
            ALPHABET.lazy.each do |char4|
              ALPHABET.lazy.each do |char5|
                candidate_string = char1 + char2 + char3 + char4 + char5
                y.yield(raffle_candidate_string)
              end
            end
          end
        end
      end
    end
  end

  def next
    @raffle_number_generator.next
  end
end

def make_ractor(id, digest, algorithm)
  Ractor.new(id, digest, algorithm) do |id, digest, algorithm|
    alphabet = %w(a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9)
    raffle_number_generator = Enumerator.new do |y|
      alphabet.each do |char1|
        alphabet.each do |char2|
          alphabet.each do |char3|
            alphabet.each do |char4|
              alphabet.each do |char5|
                candidate_string = char1 + char2 + char3 + char4 + char5
                y.yield(candidate_string)
              end
            end
          end
        end
      end
    end

    raffle_number_generator.each do |candidate|
      if algorithm.base64digest(id + candidate) == digest
        Ractor.yield([candidate, algorithm])
      end
    end
  end
end

ractors = [Digest::SHA2, Digest::MD5, Digest::SHA256, Digest::SHA384, Digest::SHA512].map do |algorithm|
  make_ractor(id, digest, algorithm)
end

_, obj = Ractor.select(*ractors)
raffle_number, algorithm = obj
puts "Found it! Your raffle number is #{raffle_number} using #{algorithm}"
# There is no need to cleanly terminate the ractors. Exiting should kill the main process, and its main Ractor, as well as 'child' Ractors (according to the docs)
exit(0)
