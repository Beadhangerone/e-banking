require './common'

class Account
  attr_accessor :name, :balance, :currency, :owner, :category, :role, :transactions
  def set_attrs(b)
    @name = parse(b, 'h4[ng-bind="model.acc.acDesc"]')[0].text.split.join(" ")
    @balance = parse(b, 'h3[ng-bind="model.acc.acyAvlBal | sgCurrency : model.acc.ccy"]')[0].text.to_f
    @currency = parse(b, 'dd[ng-bind="model.acc.ccy"]')[0].text
    @owner = parse(b, 'dd[ng-bind="currentCustomer | custNameTranslateFilter"]')[0].text
    @category = parse(b, 'dd[ng-if="model.acc.category"]')[0].text
    @role = parse(b, 'dd[ng-bind="model.custAcc.ibRoleId"]')[0].text
  end
end
