require 'watir'
require './common'
class Transaction
  attr_accessor :date, :amount, :description

  def set_attrs(b)
    @date = parse(b, 'span[bo-bind="row.dateTime | sgDate"]')[0].text
    @amount = get_amount(b)
    @description = get_desc(b) # Try without self
  end

  def get_amount(b)
    amt = parse(b, 'span[bo-bind="row.drAmount | sgCurrency"]')[0].text
    amt = parse(b, 'span[bo-bind="row.crAmount | sgCurrency"]')[0].text if amt == '0.00'
    amt
  end

  def get_desc(b)
    desc = parse(b, 'span[bo-bind="row.remI"]')[0].text
    desc = parse(b, '[bo-bind="row.trname"]')[0].text if desc == ''
    desc
  end
end
