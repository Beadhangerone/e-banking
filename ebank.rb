require "rubygems"
require "watir"
require "open-uri"


#watir
client = Selenium::WebDriver::Remote::Http::Default.new
client.read_timeout = 120 # seconds
driver = Selenium::WebDriver.for :chrome, http_client: client
b = Watir::Browser.new driver
b.goto('https://my.fibank.bg/oauth2-server/login?client_id=E_BANK')
browser.link(:id =>"demo-link").click
