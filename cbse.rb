#!/usr/bin/ruby1.9.1

require 'csv'
require 'mechanize'

agent = Mechanize.new{ |agent| agent.history.max_size=0 }

agent.user_agent = 'Mozilla/5.0'

url = "http://www.cbseresults.nic.in/class12/cbse122013.htm"

page = agent.get(url)

uform = page.forms[0]
uform.regno = "1601215"
uform.action = "cbse122013.asp"
page = agent.submit(uform)

#page.parser.xpath("//tr/td").each do |td|
#  p td.text
#  p td.path
#end

students = CSV.open("cbse_students.csv","w")
scores = CSV.open("cbse_scores.csv","w")
results = CSV.open("cbse_results.csv","w")

student_path = "/html/body/div[2]/table[2]/tr[position()>=1 and position()<=4]/td[2]"
score_path = "/html/body/div[2]/div/center/table/tr[position()>1]"

codes = ["16","17","18","19","26","27","28","29","36","37","38","39","46","47","48","49","56","57","58","59","66","67","68","69","76","77","78","79","91","92","93","94","95","96","97","98","99"]

max_failure = 3

(1..99999).each do |post_id|

  page = agent.get(url)

  uform = page.forms[0]
  uform.regno = "16%05d" % post_id
  uform.action = "cbse122013.asp"
  page = agent.submit(uform)

  row = []
  page.parser.xpath(student_path).each do |td|
    row << td.text.delete("^\u{0000}-\u{007F}").strip
  end
  students << row

  roll_no = row[0]

  #gsub(/\s+/, ' ').strip

  page.parser.xpath(score_path).each do |tr|
    row = [roll_no]
    tr.xpath("td[position()>=1 and position()<=4]").each do |td|
      row << td.text.delete("^\u{0000}-\u{007F}").strip
    end
    scores << row
  end

  students.flush
  scores.flush

end
