require 'yaml'
require 'active_support/core_ext/hash/indifferent_access'
require 'net/http'
require 'uri'
require 'json'

class RecaptchaVerificationService
  attr_writer :response, :action, :address

  def execute
    load_config
    build_query
    verify_response
    persist_failure unless @results['success']
    @results['success']
  end

  private

  def load_config
    @config = YAML.load_file('config/recaptcha.yml').with_indifferent_access[@action]
  end

  def build_query
    @query = { :secret => @config[:secret], :response => @response, :remoteip => @address }
  end

  def verify_response
    uri = URI.parse('https://www.google.com/recaptcha/api/siteverify')
    response = Net::HTTP.post_form(uri, @query)
    @results = JSON.parse(response.body)
  end

  def persist_failure
    RecaptchaFailure.create(
      :challenge_timestamp => @results['challenge_ts'],
      :hostname => @results['hostname'],
      :address => @address,
      :error_codes => @results['error-codes'].join(', ')
    )
  end
end