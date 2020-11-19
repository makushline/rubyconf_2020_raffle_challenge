# rubyconf_2020_raffle_challenge

## Solutions
* Ractor based solution from [Kush Fanikiso](https://github.com/makushline)
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
