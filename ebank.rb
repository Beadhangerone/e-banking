require "rubygems"
require "watir"
require "open-uri"
require "./account"
require "./transaction"
require "./captcha"

def toHash(obj)
  hash = {}
  obj.instance_variables.each {|var| hash[var[1..-1]] = obj.instance_variable_get var}
  hash
end

def click(element)
  # puts(element.text)
  element.wait_until(&:present?).click!
  return element
end
def wait(element)
  nil until element.present?
  return element
end

def separator(n)
  puts '-'*n
end


# Captcha
puts 'To start using this software, please answer this math question (using numbers):'
begin
  print( (captcha = Captcha.new).text )
  ans = captcha.check(gets())
end until ans


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

#get info about accounts
info = {accounts:[]}
f = File.open("info.json", "w")
acc_boxes.each{|acc_box|
  click(wait(acc_box.element(css:'div.bg-circle-acc a'))) #Go to the 'account info' page
  sleep(1)
  new_acc = Account.new
  new_acc.name = b.element(css:'h4[ng-bind="model.acc.acDesc"]').text
  new_acc.balance = b.element(css:'h3[ng-bind="model.acc.acyAvlBal | sgCurrency : model.acc.ccy"]').text.to_f
  new_acc.currency = b.element(css:'dd[ng-bind="model.acc.ccy"]').text
  new_acc.owner = b.element(css:'dd[ng-bind="currentCustomer | custNameTranslateFilter"]').text
  new_acc.category = b.element(css:'dd[ng-if="model.acc.category"]').text
  new_acc.role = b.element(css:'dd[ng-bind="model.custAcc.ibRoleId"]').text
  new_acc.transactions = []

  # Get account's transactions
  click(b.link(href:'/EBank/accounts/statement/new')) #Go to the 'statements' page
  click(b.form(name:'form').button(class:'dropdown-toggle')) #Set filters
  click(wait(b.ul(class:['dropdown-menu', 'inner'])).span(text:new_acc.name))
  wait(b.element(css: 'div#sg-date-from').text_field()).set('01/01/1900')
  b.send_keys :enter

  transactions = wait(b.table(id:'accountStatements')).elements(css:'tbody tr[ng-repeat="row in dataSource.filteredData | limitTo:dataSource.itemsToDisplay"]')
  tr_len = transactions.length
  separator(40)
  puts("This account has #{tr_len} transactions:")
  transactions.each_with_index {|t, i|
    trans = Transaction.new
    trans.date = t.element(css:'span[bo-bind="row.dateTime | sgDate"]').text
    trans.amount = Transaction.get_amount(t)
    trans.description = Transaction.get_desc(t)
    new_acc.transactions << toHash(trans)
    print("#{i*100/tr_len}% of transactions processed. \r")
  }

  info[:accounts] << toHash(new_acc)
  click(wait(b.link(href:'/EBank/accounts')))#Go back
}
# Write data to the file
File.open("info.json", "a") {|f| f.write(JSON.pretty_generate(info)) }
puts("All data scraped, and stored in 'info.json' file.")
sleep(5)
