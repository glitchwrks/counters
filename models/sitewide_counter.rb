class SitewideCounter < Counter

  def sitewide_ipv4_hit_count
    Counter.sum(:ipv4_preload) + Hit.distinct.where(:ipv6 => false).count(:address)
  end

  alias_method :ipv4_hit_count, :sitewide_ipv4_hit_count

  def sitewide_ipv6_hit_count
    Counter.sum(:ipv6_preload) + Hit.distinct.where(:ipv6 => true).count(:address)
  end

  alias_method :ipv6_hit_count, :sitewide_ipv6_hit_count
end