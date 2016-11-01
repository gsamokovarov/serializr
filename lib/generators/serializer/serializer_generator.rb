# frozen_string_literal: true

require_relative '../serializr/serializr_generator'

class SerializerGenerator < SerializrGenerator
  source_root File.expand_path('../../serializr/templates', __FILE__)
end
