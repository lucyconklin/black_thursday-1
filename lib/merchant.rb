require 'pry'
require 'csv'

class Merchant
  attr_reader :id,
              :name

  def initialize(hash)
    @id   = hash[:id]
    @name = hash[:name]
  end

  # def id
  #   @id
  # end
end
