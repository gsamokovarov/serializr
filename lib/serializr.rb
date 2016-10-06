require 'serializr/attributes'
require 'serializr/collection'

# The serializer name is taken as a gem, that's why the broken name.
#
# I wanna introduce a really simple serializer, so we don't depend on the
# overblown active_model_serializers.
#
# This will live in it's own gem, eventually.
class Serializr
  extend Attributes
  extend Collection

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
