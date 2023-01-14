class CollisionMaker
  def self.touch
    @@invocation_count ||= 0
    @@raised_error ||= false
    @@invocation_count += 1

    if @@invocation_count > 1
      'It retried'
    else
      @@raised_error = true
      raise ActiveRecord::RecordNotUnique
    end
  end

  def self.new_record?
    false
  end

  def self.invocation_count
    @@invocation_count ||= 0
  end

  def self.raised_error?
    @@raised_error
  end

  def self.reset!
    @@invocation_count = 0
    @@raised_error = false
  end
end
