require 'yaml'
require 'active_support/core_ext/hash/indifferent_access'

class SendTextEmailService
  attr_writer :content, :source_email, :destination_email

  def execute
    load_configuration
    send_email
  end

  private

  def load_configuration
    @config = YAML.load_file('config/email.yml').with_indifferent_access[Sinatra::Base.environment]
  end

  def send_email
    smtp = Net::SMTP.new(@config['server'], @config['port'])
    smtp.enable_starttls
    smtp.start(@config['domain'], @config['username'], @config['password'])
    smtp.send_message(@content, @source_email, @destination_email)
  end
end