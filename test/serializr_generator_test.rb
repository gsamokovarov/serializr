require 'test_helper'

class SerializrGeneratorTest < Rails::Generators::TestCase
  tests SerializrGenerator
  destination File.expand_path('../tmp', __FILE__)

  setup :prepare_destination
  teardown :prepare_destination

  test 'basic usage without attributes' do
    run_generator %w(User)

    assert_file "app/serializers/application_serializer.rb"
    assert_file "app/serializers/user_serializer.rb" do |content|
      assert_match(/class UserSerializer < ApplicationSerializer/, content)
    end
  end

  test 'basic usage with attributes' do
    run_generator %w(User id name email)

    assert_file "app/serializers/user_serializer.rb" do |content|
      assert_match(/attributes :id, :name, :email/, content)
    end
  end
end
