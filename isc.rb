#!/usr/bin/ruby1.9.1

require 'csv'
require 'mechanize'

agent = Mechanize.new{ |agent| agent.history.max_size=0 }

agent.user_agent = 'Mozilla/5.0'

base = "http://www.cisce.ndtv.com/web/12th/12-"

students = CSV.open("isc_students.csv","w")
scores = CSV.open("isc_scores.csv","w")

student_path = "/html/body/table[1]/tr"
score_path = "/html/body/tr/td/table/tr[position()>1]"

servers = 4
max_failure = 3

(9001..9793).each do |school_id|

  failure = 0
  print "Pulling #{school_id}\n"
  print "  "

  (1..999).each do |student_id|
    
    if (failure>max_failure)
      print " - done\n"
      break
    end

    server = 1
    begin
      url = "#{base}#{server}/#{school_id}%03d.html" % student_id
      page = agent.get(url)
      failure = 0
    rescue
      if (server<servers)
        server += 1
        retry
      else
        failure += 1
        print "#{failure}"
        next
      end
    end

    row = []
    page.parser.xpath(student_path).each do |tr|
      tr.xpath("td[2]").each do |td|
        row << td.text.strip
      end
    end
    students << row

    page.parser.xpath(score_path).each do |tr|
      score = row[0..0]
      tr.xpath("td").each do |td|
        score << td.text.strip
      end
      scores << score
    end

  end
  scores.flush
  students.flush

end
