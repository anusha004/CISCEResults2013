#!/usr/bin/ruby1.9.1

require 'csv'
require 'mechanize'

agent = Mechanize.new{ |agent| agent.history.max_size=0 }

agent.user_agent = 'Mozilla/5.0'

url = "http://www.cbseresults.nic.in/class12/cbse122013.htm"

page = agent.get(url)

instance = ARGV[0].to_i

student_path = "/html/body/div[2]/table[2]/tr[position()>=1 and position()<=4]/td[2]"
score_path = "/html/body/div[2]/div/center/table/tr[position()>1]"

#codes = [16,17,18,19,26,27,28,29,36,37,38,39,46,47,48,49,56,57,58,59,66,67,68,69,76,77,78,79,91,92,93,94,95,96,97,98,99]

codes = [17,18,19,26,27,28,29,36,37,38,39,46,47,48,49,56,57,58,59,66,67,68,69,76,77,78,79,91,92,93,94,95,96,97,98,99]

codes.each do |code|

  students = CSV.open("#{code}/cbse_students#{instance}.csv","w")
  scores = CSV.open("#{code}/cbse_scores#{instance}.csv","w")

  (((instance-1)*1000+1)..(instance*1000)).each do |post_id|

    if (post_id%100==0)
      print "  #{code} - #{post_id}\n"
      students.flush
      scores.flush
      # refresh connection
      begin
        page = agent.get(url)
      rescue
        retry
      end
    end

    uform = page.forms[0]
    uform.regno = "#{code}%05d" % post_id
    uform.action = "cbse122013.asp"

    begin
      rpage = agent.submit(uform)
    rescue
      page = agent.get(url)
      retry
    end

    row = []
    rpage.parser.xpath(student_path).each do |td|
      row << td.text.delete("^\u{0000}-\u{007F}").strip
    end
    if (row.size>0)
      students << row
    else
      next
    end

    roll_no = row[0]

    #gsub(/\s+/, ' ').strip

    rpage.parser.xpath(score_path).each do |tr|
      row = [roll_no]
      tr.xpath("td[position()>=1 and position()<=4]").each do |td|
        row << td.text.delete("^\u{0000}-\u{007F}").strip
      end
      scores << row
    end
  end

  students.close
  scores.close

end
