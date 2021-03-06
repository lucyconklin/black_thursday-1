require 'csv'
require_relative '../lib/invoice_item'

class InvoiceItemRepository

  attr_reader :csv,
              :all,
              :parent

  def initialize(path, sales_engine)
    @all    = []
    @parent = sales_engine
    csv_load(path)
    load_all
  end

  def csv_load(path)
    @csv = CSV.open path, headers: true, header_converters: :symbol
  end

  def load_all
    @all = csv.collect {|line| InvoiceItem.new(line, self)}
  end

  def find_by_id(id)
    all.find { |invoice_item| invoice_item.id == id }
  end

  def find_all_by_item_id(id)
    all.find_all { |invoice_item| invoice_item.item_id == id }
  end

  def find_all_by_invoice_id(id)
    all.find_all {|invoice_item| invoice_item.invoice_id == id}
  end

  def find_items(item_id)
    @parent.find_items_by_item_id(item_id)
  end

  def inspect
  end
end
