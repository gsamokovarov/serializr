# The serializer name is taken as a gem, that's why the broken name.
#
# I wanna introduce a really simple serializer, so we don't depend on the
# overblown active_model_serializers.
#
# This will live in it's own gem, eventually.
class Serializr
  class << self
    NOT_GIVEN = Object.new

    def [](object = NOT_GIVEN, options = {})
      cls = collection_class_cache[self]

      if object == NOT_GIVEN
        cls
      else
        cls.new(object, options)
      end
    end

    def attributes(*attr_names)
      @attrs ||= []

      if attr_names.empty?
        @attrs
      else
        @attrs.concat(attr_names)
        attr_names.each { |attr| define_attribute_method(attr) }
      end
    end

    private

    def inherited(cls)
      unless self == Serializr
        attrs_copy = [].concat(@attrs ||= [])
        cls.instance_variable_set(:@attrs, attrs_copy)
      end
    end

    def collection_class_cache
      @collection_class_cache ||= Hash.new do |_, cls|
        Class.new(cls) do
          def as_json
            serializer = self.class.superclass
            object.map { |obj| serializer.new(obj, options).as_json }
          end
        end
      end
    end

    def define_attribute_method(attr_name)
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{attr_name}() object.#{attr_name} end
      RUBY
    end
  end

  def initialize(object, options = {})
    @object  = object
    @options = options
  end

  def as_json
    Hash[self.class.attributes.map do |attr|
      [attr, public_send(attr).as_json]
    end]
  end

  private

  attr_reader :object, :options
end
