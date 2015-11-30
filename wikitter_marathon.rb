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
  if result = Nokogiri::HTML(html_string).css('#display-result > div:nth-child(3) > span > span').first
    return result.content
  end

  return -1
end

def fetch_short_pages
  html_string = `curl -sS https://ja.wikipedia.org/wiki/Wikipedia:%E7%9F%AD%E3%81%84%E3%83%9A%E3%83%BC%E3%82%B8`
  if result = Nokogiri::HTML(html_string).css('#mw-content-text > ol > li > a')
    return result.map {|a| a.content }
  end
  return []
end

def fetch_special_short_pages(limit, offset)
  html_string = `curl -sS https://ja.wikipedia.org/w/index.php\\?title=特別:短いページ\\&limit=#{limit}\\&offset=#{offset}`
  if result = Nokogiri::HTML(html_string).css('#mw-content-text > div > ol > li > a:nth-child(2)')
    return result.map {|a| a.content }
  end
  return []
end

dist = 0
offset = 0
short_pages = fetch_short_pages()

until dist >= 7 do
  if short_pages.empty?
    limit = 100
    short_pages = fetch_special_short_pages(limit, offset)
    offset += limit
  end

  unless w = short_pages.shift()
    w = fetch_random_keyword()
  end

  d = calc_dist(w).to_i
  puts "#{w}: #{d}"
  dist = d
  sleep rand(5) + 1    # 1~5秒待つ
end
