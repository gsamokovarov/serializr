class Serializr
  # Defines the attributes class macro and the inheritance of attributes in
  # subclasses.
  module Attributes
    def inherited(klass)
      unless self == Serializr
        attrs_copy = [].concat(attrs)
        klass.instance_variable_set(:@attrs, attrs_copy)
      end
    end

    def attributes(*attr_names)
      if attr_names.empty?
        attrs
      else
        self.attrs = attr_names
        attr_names.each { |attr| define_attribute_method(attr) }
      end
    end

    private

    def attrs
      @attrs ||= []
    end

    def attrs=(value)
      attrs.concat(value)
    end

    def define_attribute_method(attr_name)
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{attr_name}
          object.#{attr_name}
        end
      RUBY
    end
  end
end
