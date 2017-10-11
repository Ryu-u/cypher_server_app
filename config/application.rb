require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CypherServer
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # template engine
    config.generators.template_engine = :slim

    config.paths.add File.join('app', 'apis'), glob: File.join('**', '*.rb')
    config.autoload_paths += Dir[Rails.root.join('app', 'apis' , '*')]

    config.middleware.use(Rack::Config) do |env|
      env['api.tilt.root'] = Rails.root.join 'app', 'views', 'api', 'apis'
    end
  end
end

# rubyにbooleanクラスがないためここに残す
module Boolean; end
class TrueClass; include Boolean; end
class FalseClass; include Boolean; end

true.is_a?(Boolean) #=> true
false.is_a?(Boolean) #=> true