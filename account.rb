class Account
  attr_accessor :name, :balance, :currency, :owner, :category, :role
  def to_hash
    hash = {}
    self.instance_variables.each do |var|
        hash[var[1..-1]] = self.instance_variable_get var
    end
    hash
  end
end
