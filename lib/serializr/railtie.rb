class Serializr
  class Railtie < ::Rails::Railtie
    initializer 'serializr.initialize' do
      require 'serializr/abstract_controller'

      # For Rails 5, automatically include this in the API controllers.
      if defined?(ActionController::API)
        ActionController::API.include(::Serializr::AbstractController)
      end

      ActionController::Base.include(::Serializr::AbstractController)
    end
  end
end
