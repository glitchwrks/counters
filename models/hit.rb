class Hit < ActiveRecord::Base
  belongs_to :counter

  validates :address, :presence => true, :uniqueness => {:scope => :counter_id}

  # BEGIN Class Methods

  def self.process_hit(request, counter, hit = nil)
    begin
      hit ||= find_or_create_by(:address => request.ip, :counter => counter, :ipv6 => request.ip.include?(':'))
      hit.touch unless hit.new_record?
    rescue ActiveRecord::RecordNotUnique
      retry
    end
  end

  # END Class Methods
end
