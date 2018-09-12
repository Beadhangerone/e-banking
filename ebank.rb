require "rubygems"
require "watir"
require "open-uri"
require "./account"

def click(element)
  element.wait_until(&:present?).click!
  return element
end
def wait(element)
  nil until element.present?
  return element
end


#watir config
client = Selenium::WebDriver::Remote::Http::Default.new
client.read_timeout = 120 # seconds
driver = Selenium::WebDriver.for :chrome, http_client: client
b = Watir::Browser.new driver
b.window.maximize
#navigate
b.goto('https://my.fibank.bg/oauth2-server/login?client_id=E_BANK')
click(b.element(css: 'nav a[ng-click="changeLang(notSelectedLang)"]'))#toggle English language
click(b.element(css: "a#demo-link"))#Go to the 'demo' page

click(wait(b.link(id: 'step3'))) #Go to the 'all accounts' page
sleep(1)
acc_boxes = b.elements(css: 'div[ng-repeat="account in accBalanace"]')
puts "You have #{acc_boxes.length} accounts:"
@accounts = []
acc_boxes.each{|acc_box|
  # puts '--------------------------'
  click(wait(acc_box.element(css:'div.bg-circle-acc a'))) #Go to the 'account info' page
  sleep(1)
  new_acc = Account.new
  new_acc.name = b.element(css:'h4[ng-bind="model.acc.acDesc"]').text
  new_acc.balance = b.element(css:'h3[ng-bind="model.acc.acyAvlBal | sgCurrency : model.acc.ccy"]').text.to_f
  new_acc.currency = b.element(css:'dd[ng-bind="model.acc.ccy"]').text
  new_acc.owner = b.element(css:'dd[ng-bind="currentCustomer | custNameTranslateFilter"]').text
  new_acc.category = b.element(css:'dd[ng-if="model.acc.category"]').text
  new_acc.role = b.element(css:'dd[ng-bind="model.custAcc.ibRoleId"]').text

  puts JSON.pretty_generate(new_acc.to_hash)
  click(wait(b.button(class:'btn-arrow-back')))#Go back
}
