require 'nokogiri'

def fetch_random_keyword
  `curl -sSL http://ja.wikipedia.org/wiki/Special:Randompage`.match(/<title>([^<]+)<\/title>/)
  return $1.split(' - ').first
end

def fetch_todays_theme
  html_string = `curl -sS http://wikitter.info/`
  return Nokogiri::HTML(html_string).css('#theme > a').first.content
end

def calc_dist(word)
  theme = fetch_todays_theme()
  html_string = `curl -sS 'http://wikitter.info/search/s' -H 'X-Requested-With: XMLHttpRequest' --data 'start=#{theme}&goal=#{word}' --compressed`
  return Nokogiri::HTML(html_string).css('#display-result > div:nth-child(3) > span > span').first.content
end

dist = 0
untile dist >= 7 do
  w = fetch_random_keyword()
  d = calc_dist(w).to_i
  puts "#{w}: #{d}"
  dist = d
  sleep rand(5) + 1    # 1~5秒待つ
end
