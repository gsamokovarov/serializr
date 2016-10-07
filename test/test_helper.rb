$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'serializr'
require 'active_support/all'
require 'minitest/autorun'

module JsonAssertions
  def assert_as_json(object, expected)
    assert_equal normalize_jsonable(expected.as_json), normalize_jsonable(object.as_json)
  end

  private

  def normalize_jsonable(json)
    case json
    when Hash
      json.deep_stringify_keys
    when Array
      json.map { |element| normalize_jsonable(element) }
    else
      json
    end
  end
end

class ActiveSupport::TestCase
  include JsonAssertions
end
