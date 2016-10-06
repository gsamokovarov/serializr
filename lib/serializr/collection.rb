class Serializr
  module Collection
    NOT_GIVEN = Object.new

    def [](object = NOT_GIVEN, options = {})
      cls = collection_class_cache[self] ||= new_collection_class(self)
      object == NOT_GIVEN ? cls : cls.new(object, options)
    end

    private

    def collection_class_cache
      @collection_class_cache ||= {}
    end

    def new_collection_class(serializer)
      Class.new(serializer) do
        def as_json
          serializer = self.class.superclass
          object.map do |obj|
            serializer.new(obj, options).as_json
          end
        end
      end
    end
  end
end
