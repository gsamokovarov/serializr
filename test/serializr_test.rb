# frozen-string-literal: true

require 'test_helper'

class SerializrTest < ActiveSupport::TestCase
  class TestingSerializer < Serializr
    attributes :foo, :bar

    def bar
      [object.bar]
    end
  end

  class PlainSerializer < Serializr
    attributes :foo, :bar, :quux
  end

  class PlainerSerializer < PlainSerializer
    attributes :foobar

    def foobar
      if options[:special]
        'special'
      else
        "#{foo}#{bar}"
      end
    end
  end

  TestObject = Struct.new(:foo, :bar, :quux)

  test 'json serialization' do
    serializer = TestingSerializer.new(object)

    assert_equal ['bar'], serializer.bar
    assert_as_json serializer, foo: :foo, bar: [:bar]
  end

  test 'multiple serializer classes do not mix attributes' do
    serializer = PlainSerializer.new(object)

    assert_as_json serializer, foo: :foo, bar: :bar, quux: :quux
  end

  test 'can inherit attributes from other serializers' do
    serializer = PlainerSerializer.new(object)

    assert_as_json serializer, foo: :foo, bar: :bar, foobar: :foobar, quux: :quux
  end

  test 'collection class can inherit attributes from other serializers' do
    serializer = PlainerSerializer[].new([object], special: true)

    assert_as_json serializer, [foo: :foo, bar: :bar, foobar: :special, quux: :quux]
  end

  test 'collection class can be instantiated on the spot' do
    collection = [object]
    serializer = PlainerSerializer[collection, special: true]

    assert_as_json serializer, [foo: :foo, bar: :bar, foobar: :special, quux: :quux]
  end

  def object
    TestObject.new('foo', 'bar', 'quux')
  end
end
