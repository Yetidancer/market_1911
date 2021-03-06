require './lib/vendor'
require './lib/market'
require './lib/item'
require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'

class MarketTest < Minitest::Test

  def setup
    @item1 = Item.new({name: 'Peach', price: "$0.75"})
    @item2 = Item.new({name: 'Tomato', price: '$0.50'})
    @item3 = Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})
    @item4 = Item.new({name: "Banana Nice Cream", price: "$4.25"})
    @item5 = Item.new({name: 'Onion', price: '$0.25'})
    @vendor1 = Vendor.new("Rocky Mountain Fresh")
    @vendor2 = Vendor.new("Ba-Nom-a-Nom")
    @vendor3 = Vendor.new("Palisade Peach Shack")
    @market = Market.new("South Pearl Street Farmers Market")
  end

  def test_it_exists
    assert_instance_of Market, @market
  end

  def test_it_has_attributes
    assert_equal "South Pearl Street Farmers Market", @market.name
    assert_equal [], @market.vendors
  end

  def test_it_can_add_vendors
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)

    assert_equal [@vendor1, @vendor2, @vendor3], @market.vendors
  end

  def test_it_can_return_vendor_names
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)

    assert_equal ["Rocky Mountain Fresh", "Ba-Nom-a-Nom", "Palisade Peach Shack"], @market.vendor_names
  end

  def test_it_can_return_sellers_of_a_particular_item
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)
    @vendor1.stock(@item1, 35)
    @vendor1.stock(@item2, 7)
    @vendor2.stock(@item4, 50)
    @vendor2.stock(@item3, 25)
    @vendor3.stock(@item1, 65)

    assert_equal [@vendor1, @vendor3], @market.vendors_that_sell(@item1)

    assert_equal [@vendor2], @market.vendors_that_sell(@item4)
  end

  def test_it_can_return_list_of_items_sold_alphabetically
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)
    @vendor1.stock(@item1, 35)
    @vendor1.stock(@item2, 7)
    @vendor2.stock(@item4, 50)
    @vendor2.stock(@item3, 25)
    @vendor3.stock(@item1, 65)

    assert_equal ["Banana Nice Cream", "Peach", "Peach-Raspberry Nice Cream", "Tomato"], @market.sorted_item_list
  end

  def test_it_can_return_total_market_inventory
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)
    @vendor1.stock(@item1, 35)
    @vendor1.stock(@item2, 7)
    @vendor2.stock(@item4, 50)
    @vendor2.stock(@item3, 25)
    @vendor3.stock(@item1, 65)

    assert_equal ({@item1 => 100, @item2 => 7, @item4 => 50, @item3 => 25}), @market.total_inventory
  end

  def test_it_can_return_false_if_there_is_not_enough_inventory_to_sell
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)
    @vendor1.stock(@item1, 35)
    @vendor1.stock(@item2, 7)
    @vendor2.stock(@item4, 50)
    @vendor2.stock(@item3, 25)
    @vendor3.stock(@item1, 65)

    assert_equal false, @market.sell(@item1, 200)
  end

  def test_it_can_return_false_if_the_item_is_not_in_stock_by_vendors
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)
    @vendor1.stock(@item1, 35)
    @vendor1.stock(@item2, 7)
    @vendor2.stock(@item4, 50)
    @vendor2.stock(@item3, 25)
    @vendor3.stock(@item1, 65)

    assert_equal false, @market.sell(@item5, 1)
  end

  def test_sell_works_over_single_vendor
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)
    @vendor1.stock(@item1, 35)
    @vendor1.stock(@item2, 7)
    @vendor2.stock(@item4, 50)
    @vendor2.stock(@item3, 25)
    @vendor3.stock(@item1, 65)
    @market.sell(@item4, 5)

    assert_equal 45, @vendor2.check_stock(@item4)
  end

  def test_sell_works_over_multiple_vendors
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)
    @vendor1.stock(@item1, 35)
    @vendor1.stock(@item2, 7)
    @vendor2.stock(@item4, 50)
    @vendor2.stock(@item3, 25)
    @vendor3.stock(@item1, 65)
    @market.sell(@item4, 5)
    @market.sell(@item1, 40)
    
    assert_equal 0, @vendor1.check_stock(@item1)
    assert_equal 60, @vendor3.check_stock(@item1)
  end


end
