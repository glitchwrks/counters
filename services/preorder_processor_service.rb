require 'securerandom'

class PreorderProcessorService
  attr_writer :preorder, :project_name
  attr_reader :errors, :invalid_project

  def initialize
    @errors = []
  end

  def execute
    validate_fields
    load_project
    validate_project
    return if errors.size > 0
    validate_email_uniqueness
    return if errors.size > 0
    sanitize_fields
    generate_confirmation_token
    load_email_template
    generate_confirmation_email
    send_confirmation_email
    @preorder.save!
  end

  private

  def validate_fields
    errors << 'All fields must be filled out' unless @preorder.filled_out?
  end

  def load_project
    @preorder.project = Project.find_by(:name => @project_name)
  end

  def validate_project
    unless @preorder.project
      errors << 'Invalid project'
      @invalid_project = true
    end
  end

  def validate_email_uniqueness
    errors << 'This email has already been registered' if Preorder.find_by(:email => @preorder.email, :project => @preorder.project)
  end

  def sanitize_fields
    @preorder.sanitize_fields!
  end

  def generate_confirmation_token
    @preorder.confirmation_token = SecureRandom.urlsafe_base64
  end

  def load_email_template
    @template = open('templates/preorder_confirmation_email.txt.erb').read
  end

  def generate_confirmation_email
    @mail = ERB.new(@template).result(binding)
  end

  def send_confirmation_email
    mailer = SendTextEmailService.new
    mailer.content = @mail
    mailer.source_email = 'noreply@glitchwrks.com'
    mailer.destination_email = @preorder.email
    mailer.execute
  end
end