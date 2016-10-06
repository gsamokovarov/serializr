class Serializr
  # Extension for AbstactController::Base subclasses like ActionController::Base
  # or ActionController::Metal.
  #
  # Introduces a `:serializer` option that is automatically inferred by the
  # resource to be rendered in `render :json`. Setting it explicitly prevents
  # the inferring altogether.
  module AbstractController
    def _normalize_options(options)
      # The resource can be nil, check if it is explicitly passed as such.
      if options.key?(:json)
        resource = options[:json]
        serializer = options.fetch(:serializer) do
          serializer_class_cache[resource.class] ||= guess_serializer_for(resource.class)
        end

        options[:json] = serializer.new(resource, options) if serializer
      end

      super
    end

    private

    def serializer_class_cache
      @@_serializer_class_cache ||= {}
    end

    def guess_serializer_for(resource_class)
      "#{resource_class}Serializer".safe_constantize or
        # Try to infer the superclass, if someone let a serializer for it and
        # not the concrete classes. Don't go deeper, just one level is enough.
        "#{resource_class.superclass}Serializer".safe_constantize
    end
  end
end
