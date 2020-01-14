require './lib/vendor'
require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'

class VendorTest < Minitest::Test

  def setup
    # @item1 = Item.new({name: 'Peach', price: "$0.75"})
    # @item2 = Item.new({name: 'Tomato', price: '$0.50'})
    @item1 = mock('Peach')
    @item2 = mock('Tomato')
    @vendor = Vendor.new("Rocky Mountain Fresh")
  end

  def test_it_exists
    assert_instance_of Vendor, @vendor
  end

  def test_it_has_attributes
    assert_equal 'Rocky Mountain Fresh', @vendor.name
  end

  def test_inventory_starts_empty
    assert_equal ({}), @vendor.inventory
  end

  def test_vendor_can_check_stock
    assert_equal 0, @vendor.check_stock(@item1)
  end

  def test_vendor_can_stock_inventory
    @vendor.stock(@item1, 30)

    assert_equal ({@item1 => 30}), @vendor.inventory

    assert_equal 30, @vendor.check_stock(@item1)

    @vendor.stock(@item1, 25)

    assert_equal 55, @vendor.check_stock(@item1)
  end

  def test_vendor_can_stock_inventory_more_than_once
    @vendor.stock(@item1, 30)
    @vendor.stock(@item1, 25)
    @vendor.stock(@item2, 12)

    assert_equal ({@item1 => 55, @item2 => 12}), @vendor.inventory
  end
end
