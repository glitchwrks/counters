require 'sanitize'

class Message < ActiveRecord::Base
  self.inheritance_column = :sti_type

  def filled_out?
    [name, email, subject, content].all? { |field| field && field.size > 0 }
  end
  
  def spammy?
    check != 'human'
  end

  def content_contains_html?
    sanitized_content != content.gsub(/\r/,'')
  end

  def subject_contains_html?
    sanitized_subject != subject
  end

  def contains_html?
    subject_contains_html? || content_contains_html?
  end

  def sanitized_content
    @sanitized_content = Sanitize.clean(content) if @sanitized_content.blank?
    @sanitized_content
  end

  def sanitized_subject
    @sanitized_subject = Sanitize.clean(subject) if @sanitized_subject.blank?
    @sanitized_subject
  end

  def printable_content
    output = ""
    output += "*** WARNING: Original subject contained HTML, which was stripped! ***\n\n" if subject_contains_html? 
    output += "*** WARNING: Original message contained HTML, which was stripped! ***\n\n" if content_contains_html?
    output + sanitized_content
  end
end