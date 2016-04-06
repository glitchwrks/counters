require 'net/smtp'
require 'yaml'
require 'active_support/core_ext/hash/indifferent_access'

class ContactMailerService
  attr_writer :message
  attr_reader :errors

  def initialize
    @errors = []
  end

  def execute
    load_config

    if @message.spammy?
      save_failed_message
    else
      validate_fields
      return if errors.size > 0
      check_for_html
      load_template
      render_template
      send_email
    end
  end

  private

  def validate_fields
    errors << 'All fields must be filled out' unless @message.filled_out?
  end

  def load_config
    @config = YAML.load_file('config/email.yml').with_indifferent_access[:contact_mailer]
  end

  def check_for_html
    if @message.contains_html? && @config[:save_suspicious_messages]
      @message.becomes!(SuspiciousMessage).save
    end
  end

  def load_template
    @template = open('templates/contact_email.txt.erb').read
  end

  def render_template
    @mail = ERB.new(@template).result(binding)
  end

  def send_email
    mailer = SendTextEmailService.new
    mailer.content = @mail
    mailer.source_email = @message.email
    mailer.destination_email = @config[:destination_email]
    mailer.execute
  end

  def save_failed_message
    @message.becomes!(FailedMessage).save if @config[:save_failed_messages]
  end
end