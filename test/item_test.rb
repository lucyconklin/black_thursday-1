require './test/test_helper'
require './lib/item'


class ItemTest < Minitest::Test
  attr_reader :item
  def setup
    @item = Item.new({:id => 4,
                      :name => "Thing",
                      :description => "description of the thing",
                      :unit_price => BigDecimal.new(10.99,4),
                      :merchant_id => "01",
                      :created_at => "time",
                      :updated_at => "time"
                      })
  end

  def test_it_exists
    assert item
  end

  def test_it_has_id
    assert item.id
  end

  def test_it_has_name
    assert item.name
  end

  def test_it_has_description
    assert item.description
  end

  def test_it_has_unit_price
    assert item.unit_price
  end

  def test_it_has_merchant_id
    assert item.merchant_id
  end

  def test_it_has_created_at_time
    assert item.created_at
  end

  def test_it_has_updated_at
    assert item.updated_at
  end

  def test_unit_price_to_dollars_returns_correct_format
    assert_equal 0, item.find_unit_price(1200)
  end

end