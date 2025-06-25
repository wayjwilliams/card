require_relative 'config/application'

Rails.application.load_tasks if defined?(Rails)

# Conditionally load database tasks
if ENV['RAILS_ENV'] != 'production'
  begin
    require 'active_record/railties/databases'
  rescue LoadError
    # Skip loading database tasks if ActiveRecord is not present
  end
end
