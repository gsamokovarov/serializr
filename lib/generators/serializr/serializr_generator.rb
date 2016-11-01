require 'pathname'

class SerializrGenerator < Rails::Generators::NamedBase
  SERIALIZR_DIR = Pathname.new('app/serializers')

  source_root File.expand_path('../templates', __FILE__)

  argument :attributes, type: :array, default: [], banner: 'field field'

  check_class_collision suffix: 'Serializer'
  class_option :parent, type: :string, desc: 'The parent class for the generated serializr'

  def create_serializer_file
    generate_application_serilzer unless non_standard_parent_class_name?
    template 'serializr.rb', serializer_file_name
  end

  private

  def parent_class_name
    options[:parent] || 'ApplicationSerializer'
  end

  def non_standard_parent_class_name?
    parent_class_name != 'ApplicationSerializer'
  end

  def generate_application_serilzer
    if self.behavior == :invoke && !application_serilzer_exist?
      template 'application_serializr.rb', application_serilzer_file_name
    end
  end

  def application_serilzer_exist?
    file_exist = nil
    in_root { file_exist = File.exist?(application_serilzer_file_name) }
    file_exist
  end

  def serializer_file_name
    SERIALIZR_DIR.join(*class_path, "#{file_name}_serializer.rb").to_s
  end

  def application_serilzer_file_name
    SERIALIZR_DIR.join('application_serializer.rb').to_s
  end 
end
