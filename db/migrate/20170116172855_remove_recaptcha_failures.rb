class RemoveRecaptchaFailures < ActiveRecord::Migration

  def up
    drop_table :recaptcha_failures
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end