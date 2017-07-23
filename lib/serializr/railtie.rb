# frozen_string_literal: true

class Serializr
  class Railtie < ::Rails::Railtie
    config.serializr = config.serializer = ActiveSupport::OrderedOptions.new
    config.serializr.integration = true

    initializer 'serializr.initialize' do
      if config.serializr.integration
        require 'serializr/integration'

        # For Rails 5, automatically include this in the API controllers.
        if defined?(ActionController::API)
          ActionController::API.include(::Serializr::Integration)
        end

        ActionController::Base.include(::Serializr::Integration)
      end
    end
  end
end
