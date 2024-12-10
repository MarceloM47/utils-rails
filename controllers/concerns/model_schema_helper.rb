module ModelSchemaHelper
    extend ActiveSupport::Concern
  
    def get_model_schema(model_class)
      columns = model_class.columns_hash
      validations = model_class.validators
  
      schema = {}
      example = {}
  
      columns.each do |name, column|
        next if ['id', 'created_at', 'updated_at'].include?(name)
        
        is_required = validations.any? do |validator|
          validator.is_a?(ActiveRecord::Validations::PresenceValidator) &&
          validator.attributes.include?(name.to_sym)
        end
  
        schema[name] = "#{column.type}#{is_required ? ' - required' : ''}"
        
        # Generate example based in the column type
        example[name] = case column.type
          when :string
            name == 'phone' ? "+1234567890" : "Ejemplo de #{name}"
          when :text
            "Example text of #{name}"
          when :integer
            123
          when :decimal, :float
            123.45
          when :datetime, :timestamp
            Time.current
          when :boolean
            true
          else
            "Example of #{name}"
        end
      end

      model_class.nested_attributes_options.keys.each do |relation|
        related_model = model_class.reflect_on_association(relation).klass
        nested_schema = get_model_schema(related_model)
        
        schema["#{relation}_attributes"] = [nested_schema[:schema]]
        example["#{relation}_attributes"] = [nested_schema[:example]]
      end
  
      {
        schema: schema,
        example: example
      }
    end
end
