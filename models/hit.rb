class Hit < ActiveRecord::Base
  belongs_to :counter

  # BEGIN Class Methods

  def self.process_hit(request, counter)
    find_or_create_by(:address => request.ip, :counter => counter, :ipv6 => request.ip.include?(':')).touch
  end

  # END Class Methods
end