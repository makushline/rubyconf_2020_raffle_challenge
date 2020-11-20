I ran a programming challenge at RubyConf 2020. The basic premise was: 
- I gave got some id from contestants (url, pgp key, email etc)
- I concatenated the id with a raffle number and generated a digest.
- I then shared the digest back with the contestants.

The raffle number consistent of 5 characters from the following alphabet:
```ruby
  alphabet = %w[a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9]
```

## Problem Statement
If you process payments with Braintree you’ve likely seen a unique id that looks something like a1b2c3d4. This id goes by different names at different places but is often a way for a company to create a massive numbering system. Assuming an alphabet of only lower case letters and digits, the system above could be used for (26 + 10) ^ 8 = 2,821,109,907,456 combinations. That is an enormous number! Some places, including Braintree, also choose to encode some information in these ids. Without going too much into the Mathematics of hashing and encoding algorithms we can say that it’s possible to take some information, let’s say an email or url, add some other information, say a 5 character raffle number :wink:, and encode that information into a fixed length String. If you know the unique id and you have the fixed length encoded String, you can reverse engineer, by brute force, the raffle number that was concatenated to the id. That’s what we’ll be doing today!

If you’re interested, DM me a link to your rubyconf crowd cast profile or some unique identifier (email, pgp key, you name it), this will act as your id. I’ll respond with a String/digest hashed from your profile and your raffle number. Your job is to reverse engineer the digest to determine your raffle number. If you correctly calculate your raffle number, you will be entered into a raffle to win 3 new Raspberry Pi 400 units: I have provided a sample.rb file to get you started. N.B. The sample file uses SHA256 but that’s not necessarily the digest algorithm we have used.

## Hints
I gave some hints which contestants had to opt in to.

### Hint 1
The problem boils down to generating the entire set of 5 character permutations from our alphabet and testing those using the generate hash method.

### Hint 2
We are using one of the follow hashing algorithms

```
Digest.constants
# => [:SHA2, :MD5, :SHA256, :SHA384, :SHA512]
```

I'm not very good at encryption so I accidentally ended up using the weakest hashing algorithm.

```
Digest::SHA2.base64digest("abc")
# => "ungWv48Bz+pBQUDeXa4iI7ADYaOWF3qctBD/YfIAFa0="
Digest::MD5.base64digest("abc")
# => "kAFQmDzST7DWlj99KOF/cg=="
Digest::SHA256.base64digest("abc")
# => "ungWv48Bz+pBQUDeXa4iI7ADYaOWF3qctBD/YfIAFa0="
Digest::SHA384.base64digest("abc")
# => "ywB1P0WjXou1oD1pmsZQBycsMqsO3tFjGotgWkP/W+2AhgcroefMI1i67KE0yCWn"
Digest::SHA512.base64digest("abc")
# => "3a81oZNherrMQXNJriBBMRLm+k6JqX6iCp7u5ktV05ohkpkqJ0/BqDa6PCOj/uu9RU1EI2Q86A4qmslPpUyknw=="
```

## Some Solutions
* Mactor based solution
  https://github.com/makushline/rubyconf_2020_raffle_challenge/blob/main/ractor_miner.rb
* Single line solution:  
  `ruby -rdigest -e"i,h=ARGV;p [*?a..?z,*0..9].repeated_permutation(5).find{Digest::MD5.base64digest([i,*_1]*'')==h}"`
  which accepts `id` and `digest` as arguments. Example:  
  ```
  $ time ruby -rdigest -e"i,h=ARGV;p [*?a..?z,*0..9].repeated_permutation(5).find{Digest::MD5.base64digest([i,*_1]*'')==h}" "jeffdill2" "6G8jF+fGMwEjXwc3htjcZw=="
  ["f", 8, "o", "p", 5]
  
  real    0m25.601s
  user    0m25.572s
  sys     0m0.030s
  ```
  Created by [@jeffdill2](https://github.com/jeffdill2), [@sambostock](https://github.com/sambostock), and [@paracycle](https://github.com/paracycle)
