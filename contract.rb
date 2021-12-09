require 'securerandom'

require_relative './product'

# Contract represents an extended warranty for a covered product.
# A contract is in a PENDING state prior to the effective date,
# ACTIVE between effective and expiration dates, and EXPIRED after
# the expiration date.

class Contract
  attr_reader   :id # unique id
  attr_reader   :purchase_price
  attr_reader   :covered_product

  attr_accessor :status
  attr_accessor :effective_date
  attr_accessor :expiration_date
  attr_accessor :purchase_date
  attr_accessor :in_store_guarantee_days

  attr_accessor :claims

  LIABILITY_PERCENTAGE = 0.8

  def initialize(purchase_price, covered_product)
    @id                 = SecureRandom.uuid
    @purchase_price     = purchase_price
    @status             = "PENDING"
    @covered_product    = covered_product
    @claims             = Array.new
  end

  # These two new methods we've added seem to be responsibilities of Contract.
  # Let's move them...
  def limit_of_liability()
    claim_total = 0.0
    @claims.each { |claim|
      claim_total += claim.amount
    }
    # (@purchase_price - claim_total) * 0.8
    (@purchase_price * LIABILITY_PERCENTAGE) - claim_total
  end

  def current_status(current_date)
    current_date  >= @effective_date &&
    current_date  <= @expiration_date &&
    @status == "ACTIVE"
  end

  # Equality for entities is based on unique id
  def ==(other)
    self.id == other.id
  end
end
