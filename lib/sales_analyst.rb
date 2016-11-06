require 'pry'
require 'time'

class SalesAnalyst
  attr_reader :sales_engine,
              :items,
              :merchants,
              :invoices,
              :transactions

  def initialize(sales_engine)
    @sales_engine = sales_engine
    @items = load_items
    @merchants = load_merchants
    @invoices = load_invoices
    @transactions = sales_engine.transactions
  end

  def load_items
    sales_engine.load_items
  end

  def load_merchants
    sales_engine.merchants.all
  end

  def load_invoices
    sales_engine.load_invoices
  end

  # def load_transactions
  #   sales_engine.load_transactions
  # end

  def average(array)
    array.inject{ |sum, element| sum + element }.to_f / array.count
  end

  def find_standard_deviation(array)
    mean        = average(array)
    sum_squares = array.inject(0) { |sum, element| sum + (mean - element)**2 }
    Math.sqrt(sum_squares / (array.length - 1))
  end

  ### --- merchant methods --- ###

  def average_items_per_merchant
    items_count      = sales_engine.items.all.count
    merchants_count  = sales_engine.merchants.all.count
    average          = items_count.to_f / merchants_count.to_f
    average.round(2)
  end

  def average_items_per_merchant_standard_deviation
    items_per_merchant = []
    @merchants.each do |merchant_instance|
      items_per_merchant << merchant_instance.items.count
    end
    result = find_standard_deviation(items_per_merchant)
    return result.round(2)
  end

  def merchants_with_high_item_count
    std_dev = average_items_per_merchant_standard_deviation
    threshold = std_dev + average_items_per_merchant
    @merchants.find_all do |merchant|
        merchant.items.count > threshold
      end
  end

  def average_item_price_for_merchant(id)
    prices = @items[id].map { |item| item.unit_price.to_f }
    return BigDecimal.new(average(prices).to_f, 5).round(2)
  end

  def average_average_price_per_merchant
    prices = @items.keys.map do |id|
      average_item_price_for_merchant(id)
    end
    average_price = average(prices)
    return BigDecimal.new(average_price, 6).floor(2)
  end

  ### --- item methods --- ###

  def get_item_average_price
    item_prices = []
    item_prices = sales_engine.items.all.map do |item|
      item.unit_price
    end
    average(item_prices)
  end

  def get_item_standard_deviation
    item_prices = []
    item_prices = sales_engine.items.all.map do |item|
      item.unit_price
    end
    find_standard_deviation(item_prices)
  end

  def golden_items
    mean         = get_item_average_price
    std_dev      = get_item_standard_deviation
    threshold    = BigDecimal(mean + std_dev, 4)
    golden_items_compared_to_threshold(threshold)
  end

  def golden_items_compared_to_threshold(threshold)
    @sales_engine.items.all.find_all do |item|
        item.unit_price > threshold * 2
      end
  end

  ### --- invoice methods --- ###

  def average_invoices_per_merchant
    merchant_count = @merchants.count
    invoice_count  = @sales_engine.invoices.all.count
    (invoice_count.to_f/merchant_count.to_f).round(2)
  end

  def average_invoices_per_merchant_standard_deviation
    invoices_per_merchant = []
    @merchants.each do |merchant_instance|
      invoices_per_merchant << merchant_instance.invoices.count
    end
    result = find_standard_deviation(invoices_per_merchant)
    result.round(2)
  end

  def top_merchants_by_invoice_count
    std_dev = average_invoices_per_merchant_standard_deviation
    threshold = (std_dev * 2) + average_invoices_per_merchant
    @merchants.find_all do |merchant|
        merchant.invoices.count > threshold
      end
  end

  def bottom_merchants_by_invoice_count
    std_dev   = average_invoices_per_merchant_standard_deviation
    threshold = average_invoices_per_merchant - (std_dev * 2)
    bottom_invoice_count(threshold)
  end

  def bottom_invoice_count(threshold)
    @merchants.find_all do |merchant|
        merchant.invoices.count < threshold
      end
  end

  def top_days_by_invoice_count
    invoices_by_day = sales_engine.invoices.all.group_by do |invoice_instance|
      Time.at(invoice_instance.created_at).strftime("%A")
    end
    invoice_count = invoices_by_day.keys.map do |key|
      invoices_by_day[key].count
    end
    std_dev = find_standard_deviation(invoice_count)
    avg = average(invoice_count)
    threshold = (std_dev) + avg
    invoices_by_day.keys.select do |day|
      invoices_by_day[day].count > threshold
    end
  end

  def invoice_status(status)
    matches = sales_engine.invoices.all.find_all do |invoice_instance|
      invoice_instance.status == status
    end
    x = (matches.count / sales_engine.invoices.all.count.to_f)
    (x * 100).round(2)
  end

  ### --- relationship methods --- ###

  def total_revenue_by_date(date)
    invoice_days = sales_engine.invoices.find_all_by_date(date)
    revenue = invoice_days.map do |invoice|
      invoice.total
    end
    revenue.compact.reduce(:+)
  end

  # def top_revenue_earners(x=20)
  #   #gives top 20 merchants
  #   thing = []
  #   invoices.map do |merchant_id, values|
  #     thing << [merchant_id, values.inject(0) do |sum, invoice_instance|
  #       sum += invoice_instance.total.to_f
  #     end]
  #   end
  #   merchants = thing.sort_by(&:last).reverse[0..(x-1)]
  #   top = merchants.map do |merchant|
  #     sales_engine.merchants.find_by_id(merchant[0])
  #   end
  #   top
  #   # binding.pry
  # end

  def merchants_with_pending_invoices
    #returns an array of merchants with pending status's
  end

  def merchants_with_only_one_item
    @merchants.find_all do |merchant|
      merchant.items.count == 1
    end
  end

  def merchants_with_only_one_item_registered_in_month(months_name)
    #returns an array of merchants
    sales_engine.find_all_invoices_by_merchant_id
    merchants_with_.group_by do |merchant|
      merchant.created_at.strftime("%B").upcase == months_name.upcase
    end
  end

  def revenue_by_merchant(merchant_id)
    invoices[merchant_id].inject(0) do |sum , invoice_instance|
      sum += invoice_instance.total
    end
  end

  def most_sold_item_for_merchant(merchant_id)
    #returns array of one item instance inside, unless there is a tie of multiple items
  end

  def best_item_for_merchant(merchant_id)
    #returns an item instance by revenue generated
  end
end
