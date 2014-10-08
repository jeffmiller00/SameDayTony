#!/usr/bin/env ruby
require 'open-uri'

begin_attempt = 1412609984 + 82001
delta_attempt = 10000

rands = (begin_attempt..begin_attempt+delta_attempt).to_a
success_url_1 = success_url_2 = ''
i = 0

while !rands.empty? do
  break if !success_url_1.empty? && !success_url_2.empty?
  r = rands.shift
  puts i if i % 50 == 0
  i += 1

  base_url = 'http://cdn.stationcaster.com/stations/wtem/media/mpeg/'
  day = Time.now.day.to_s.rjust(2,'0')
  #day = '29'
  url_attempt_1 = "#{base_url}#{Time.now.month.to_s.rjust(2,'0')}_#{day}_14_The_Tony_Kornheiser_Show_Hour_1-#{r}.mp3"
  url_attempt_2 = "#{base_url}#{Time.now.month.to_s.rjust(2,'0')}_#{day}_14_The_Tony_Kornheiser_Show_Hour_2-#{r}.mp3"
  puts "Attempted URL:: #{url_attempt_1}" if i < 3


  if success_url_1 == ''
    begin
      remote_data = open("#{url_attempt_1}").read
      success_url_1 = url_attempt_1
    rescue OpenURI::HTTPError => e
      if e.message != '404 Not Found'
        puts url_attempt_1
        puts url_attempt_2
        raise e
      end
    end
  end


  if success_url_2 == ''
    begin
      remote_data = open("#{url_attempt_2}").read
      success_url_2 = url_attempt_2
    rescue OpenURI::HTTPError => e
      if e.message == '404 Not Found'
        puts success_url_1 if i % 500 == 0
        next
      else
        puts url_attempt_1
        puts url_attempt_2
        raise e
      end
    end
  end
end

puts "1st Ep: #{success_url_1}"
puts "2nd Ep: #{success_url_2}"
puts "Last  : #{last}"