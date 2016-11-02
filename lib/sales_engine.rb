require 'pry'
require './lib/merchant_repository'
require './lib/item_repository'
require 'csv'

class SalesEngine
  attr_reader :merchants,
              :items

  def initialize(hash)
    @items     =  ItemRepository.new(hash[:items])
    @merchants =  MerchantRepository.new(hash[:merchants])
  end

  def self.from_csv(hash)
    SalesEngine.new(hash)
  end
end
