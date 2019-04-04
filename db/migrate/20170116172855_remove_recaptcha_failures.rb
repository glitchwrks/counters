class RemoveRecaptchaFailures < ActiveRecord::Migration[5.2]

  def up
    drop_table :recaptcha_failures
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end