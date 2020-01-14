class Vendor

  attr_reader :name, :inventory
  def initialize(name)
    @name = name
    @inventory = {}
  end

  def check_stock(item)
    return @inventory[item] if @inventory[item]
    0
  end

  def stock(item, amount)
    if @inventory[item]
      @inventory[item] += amount
    else
      @inventory[item] = amount
    end
  end

  def sell(item, amount)
    sold = 0
    if @inventory[item] && @inventory[item] > amount
      @inventory[item] -= amount
    elsif @inventory[item] && @inventory[item] <= amount
      sold = @inventory[item]
      @inventory[item] = 0
    end
    sold
  end
end
