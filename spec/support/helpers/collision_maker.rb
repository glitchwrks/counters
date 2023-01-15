class CollisionMaker
  attr_reader :invocation_count, :raised_error

  def initialize 
    reset!
  end

  def touch
    @invocation_count += 1

    if @invocation_count > 1
      self
    else
      @raised_error = true
      raise ActiveRecord::RecordNotUnique
    end
  end

  def new_record?
    false
  end

  def reset!
    @invocation_count = 0
    @raised_error = false
  end
end
