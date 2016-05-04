require 'sanitize'

class Preorder < ActiveRecord::Base
  self.inheritance_column = :sti_type

  belongs_to :project

  def filled_out?
    [name, email].all? { |field| field && field.size > 0 }
  end

  def sanitize_fields!
    self.name = Sanitize.clean(name)
    self.email = Sanitize.clean(email)
    self.boards = Sanitize.clean(boards)
    self.kits = Sanitize.clean(kits)
    self.assembled = Sanitize.clean(assembled)
  end
end