require 'nokogiri'
require 'watir'

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
  element.wait_until(&:present?).click! # Try wait
  element
end

def wait(element)
  nil until element.present?
  element
end

def separator(n)
  puts '-' * n
end
