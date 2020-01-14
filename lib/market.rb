class Market

  attr_reader :name, :vendors
  def initialize(name)
    @name = name
    @vendors = []
  end

  def add_vendor(vendor)
    @vendors << vendor
  end

  def vendor_names
    @vendors.map {|vendor| vendor.name}
  end

  def vendors_that_sell(item)
    @vendors.find_all {|vendor| vendor.inventory.include?(item)}
  end

  def sorted_item_list
    item_list = @vendors.reduce([]) do |list, vendor|
      list << vendor.inventory.keys
      list
    end.flatten
    item_list.map {|item| item.name}.uniq.sort
  end

  def total_inventory
    @vendors.reduce({}) do |all_items, vendor|
      vendor.inventory.each do |item, amount|
        if all_items[item]
          all_items[item] += amount
        else
          all_items[item] = amount
        end
      end
      all_items
    end
  end

  def sell(item, amount)
    return false if total_inventory.keys.include?(item) == false
    return false if amount > total_inventory[item]
    @vendors.each do |vendor|
      amount -= vendor.sell(item, amount)
    end
    true
  end
end
