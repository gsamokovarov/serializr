class Serializr
  class << self
    NOT_GIVEN = Object.new

    def [](object = NOT_GIVEN, options = {})
      cls = collection_class_cache[self]
      object == NOT_GIVEN ? cls : cls.new(object, options)
    end

    def attributes(*attr_names)
      if attr_names.empty?
        @attrs ||= []
      else
        (@attrs ||= []).concat(attr_names)
        attr_names.each { |attr| define_attribute_method(attr) }
      end
    end

    private

    def inherited(cls)
      return if self == Serializr

      attrs_copy = [].concat(@attrs ||= [])
      cls.instance_variable_set(:@attrs, attrs_copy)
    end

    def collection_class_cache
      @@collection_class_cache ||= Hash.new do |hash, cls|
        hash[cls] = Class.new(cls) do
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

# Let's get the constant, even if we don't explicitly `require 'serializer'`.
Serializer = Serializr

require 'serializr/railtie' if defined?(Rails)
