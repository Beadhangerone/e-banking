require 'nokogiri'
require 'watir'

def get_period
  print('For how many months ago do you want to see transactions? Leave blank to see all the transactions: ')
  months = gets.to_i
  date = DateTime.now
  months.times do date = date.prev_month end
  date = date.strftime('%d/%m/%Y')
  date = '01/01/1900' if months.zero?
  date.to_s
end

def toHash(obj)
  hash = {}
  obj.instance_variables.each { |var| hash[var[1..-1]] = obj.instance_variable_get var }
  hash
end

def parse(b, selector)
  page = Nokogiri::HTML.parse(b.html)
  page.css(selector)
end

def click(element)
  # puts(element.text)
  wait(element).wait_until(&:present?).click!
  element
end

def wait(element)
  nil until element.present?
  element
end

def separator(n)
  puts '-' * n
end
