class Counter < ActiveRecord::Base
  self.inheritance_column = :sti_type

  has_many :hits, :dependent => :destroy

  validates :name, :presence => true, :uniqueness => true

  def counter_specific_ipv4_hit_count
    ipv4_preload + hits.where(:ipv6 => false).size
  end

  alias_method :ipv4_hit_count, :counter_specific_ipv4_hit_count

  def counter_specific_ipv6_hit_count
    ipv6_preload + hits.where(:ipv6 => true).size
  end

  alias_method :ipv6_hit_count, :counter_specific_ipv6_hit_count

  def javascript_hit_count(ipv6)
    output = "#{pad(ipv4_hit_count + ipv6_hit_count)}"
    output += " (#{pad(ipv6_hit_count)} on IPv6)" if ipv6

    "document.write('#{output}');"
  end

  def update_preloads!
    self.ipv4_preload = counter_specific_ipv4_hit_count
    self.ipv6_preload = counter_specific_ipv6_hit_count
    save!
    hits.destroy_all
  end

  private

  def pad(number)
    number.to_s.rjust(6, '0')
  end
end