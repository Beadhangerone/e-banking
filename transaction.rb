require 'watir'
class Transaction
  attr_accessor :date, :amount, :description

  def set_attrs(b)
    @date = b.element(css: 'span[bo-bind="row.dateTime | sgDate"]').text
    @amount = self.get_amount(b)
    @description = self.get_desc(b)
  end

  def self.get_amount(t)
    amt = t.element(css: 'span[bo-bind="row.drAmount | sgCurrency"]').text
    amt = t.element(css: 'span[bo-bind="row.crAmount | sgCurrency"]').text if amt == '0.00'
    amt
  end

  def self.get_desc(t)
    desc = t.element(css: 'span[bo-bind="row.remI"]').text
    desc = t.element(css: '[bo-bind="row.trname"]').text if desc == ''
    desc
  end
end
