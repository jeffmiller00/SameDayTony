#!/usr/bin/env ruby
require 'open-uri'

raw_html = open("http://www.stationcaster.com/player_skinned.php?s=65&c=580&f=3427483").read
episode_list = raw_html.scan(/\d\d_\d\d_\d\d_The_Tony_Kornheiser_Show_Hour_\d-\d*.mp3/).reverse

all = []

episode_list.each do |ep|
  all << (ep.split('-'))[1].split('.')[0].to_i
end

all.sort!

puts '|------------------------------------------|'
puts all.max
puts '|------------------------------------------|'

diffs = []

last = 0
all.each do |n|
  diffs << n - last
  last = n
end

diffs.shift
puts diffs