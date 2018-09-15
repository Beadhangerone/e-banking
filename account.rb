require "watir"
class Account
  attr_accessor :name, :balance, :currency, :owner, :category, :role, :transactions
  def set_attrs(b)
    @name = b.element(css: 'h4[ng-bind="model.acc.acDesc"]').text
    @balance = b.element(css: 'h3[ng-bind="model.acc.acyAvlBal | sgCurrency : model.acc.ccy"]').text.to_f
    @currency = b.element(css: 'dd[ng-bind="model.acc.ccy"]').text
    @owner = b.element(css: 'dd[ng-bind="currentCustomer | custNameTranslateFilter"]').text
    @category = b.element(css: 'dd[ng-if="model.acc.category"]').text
    @role = b.element(css: 'dd[ng-bind="model.custAcc.ibRoleId"]').text
  end
end
