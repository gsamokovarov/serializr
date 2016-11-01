class Serializr
  # Integration for AbstactController::Metal subclasses like
  # ActionController::Base or ActionController::API.
  #
  # Introduces a `:serializer` option that is automatically inferred by the
  # resource to be rendered in `render :json`.
  #
  # Setting it explicitly prevents the inferring altogether.
  module Integration
    def _normalize_options(options)
      # The resource can be nil, check if it is explicitly passed as such.
      if options.key?(:json)
        resource = options[:json]
        serializer = options[:serializer] || begin
          if resource.respond_to?(:to_ary)
            # Assume a collection if the resource responds to #to_ary. The
            # regular arrays and ActiveRecord::Relations do and will be
            # represented as arrays, while hashes won't be.
            inferred = serializer_class_cache[resource.to_ary.first.class]
            inferred[] if inferred
          else
            serializer_class_cache[resource.class]
          end
        end

        options[:json] = serializer.new(resource, options) if serializer
      end

      super
    end

    private

    def serializer_class_cache
      @@_serializer_class_cache ||= Hash.new do |hash, cls|
        hash[cls] = "#{cls}Serializer".safe_constantize ||
          # Try to infer the superclass, if someone let a serializer for it and
          # not the concrete classes. Don't go deeper, though, just one level
          # is enough.
          "#{cls.superclass}Serializer".safe_constantize
      end
    end
  end
end
