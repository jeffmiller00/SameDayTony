#!/usr/bin/env ruby
require 'thread'
require 'open-uri'
require 'time'
#require 'pry'
start = Time.now
work_q = Queue.new

projected_time= 1421426248 + (1 * 23 * 60 * 60) + 80000
begin_attempt = [projected_time, Time.parse('10:45 am CST').to_i].min
begin_attempt = Time.parse('9:15 am CST').to_i
#begin_attempt = 1425915626 + 50000
delta_attempt = 100000
(begin_attempt..begin_attempt+delta_attempt).to_a.each{|x| work_q.push x }
success_url_1 = ''
success_url_2 = ''

workers = (0...12).map do
  Thread.new do
    begin
      while r = work_q.pop(true)
        break if !success_url_1.empty? && !success_url_2.empty?
        base_url = 'http://cdn.stationcaster.com/stations/wtem/media/mpeg/'
        day = Time.now.day.to_s.rjust(2,'0')
        #day = '10'
        url_attempt_1 = "#{base_url}#{Time.now.month.to_s.rjust(2,'0')}_#{day}_15_The_Tony_Kornheiser_Show_Hour_1-#{r}.mp3"
        url_attempt_2 = "#{base_url}#{Time.now.month.to_s.rjust(2,'0')}_#{day}_15_The_Tony_Kornheiser_Show_Hour_2-#{r}.mp3"

        puts work_q.size if work_q.size % 100 == 0
        #puts url_attempt_1

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


        begin
          remote_data = open("#{url_attempt_2}").read
          success_url_2 = url_attempt_2
        rescue OpenURI::HTTPError => e
          if e.message == '404 Not Found'
            puts success_url_1 if work_q.size % 1000 == 0
            next
          else
            puts url_attempt_1
            puts url_attempt_2
            raise e
          end
        end
      end
    rescue ThreadError
    end
  end
end; "ok"
workers.map(&:join); "ok"

puts '===================================================='
puts '===================================================='
puts "1st Ep: #{success_url_1}"
puts "2nd Ep: #{success_url_2}"
puts "Last  : #{begin_attempt + delta_attempt}"
puts "Time  : #{Time.now - start}"
puts '===================================================='
puts "#{Time.now.month}/#{Time.now.day}/15 Ep 1: #{success_url_1} #freemrtony @TKLittles"
puts "#{Time.now.month}/#{Time.now.day}/15 Ep 2: #{success_url_2} #freemrtony @TKLittles"
