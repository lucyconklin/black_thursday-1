require_relative 'test_helper'
require_relative '../lib/sales_analyst'
require_relative '../lib/sales_engine'


class SalesAnalystTest < Minitest::Test
  attr_reader :se,
              :sa

  def setup
    @se = SalesEngine.from_csv({
  :items     => "./fixture/items_fixture_3.csv",
  :merchants => "./fixture/merchants_fixture_3.csv",
  })
  @sa = SalesAnalyst.new(@se)
  end

  def test_it_exists
    assert @sa
  end

  def test_load_items_returns_hash
    assert_equal Hash, sa.items.class
  end

  def test_merchants_is_array_class
    assert_equal Array, sa.merchants.class
  end

  def test_new_sales_analyst_initializes_as_sales_engine
    result= sa.sales_engine.class
    assert_equal SalesEngine, result
  end

  def test_average_gives_average
    array = [3,4,5]
    result = sa.average(array)
    assert_equal 4, result
  end

  def test_average_items_per_merchant
    result = sa.average_items_per_merchant
    assert_equal 1.21, result
  end

  def test_standard_deviation_gives_standard_dev
    array = [3,4,5]
    result = sa.find_standard_deviation(array)
    assert_equal 1, result
  end

  def test_average_items_per_merchant_std_dev
    result = sa.average_items_per_merchant_standard_deviation
    assert_equal 0.37, result
    assert_equal Float, result.class
  end

  def test_it_finds_merchants_with_high_item_counts
    result = sa.merchants_with_high_item_count
    assert_equal "BloominScents", result.first.name
  end

  def test_average_item_price_for_merchant_returns_price
    result = sa.average_item_price_for_merchant(12334105)
    assert_equal BigDecimal, result.class
    # assert this is right number?
  end
  def test_average_average_price_per_merchant
    result = sa.average_average_price_per_merchant
    assert_equal BigDecimal, result.class
    # assert this is right number?
  end

  def test_golden_items_returns_array
    result = sa.golden_items
    assert_equal Array, result.class
  end

end
