module SimpleForm
  module Inputs
    class LocalizedTextArea < LocalizedInput
      private

      def generate_input(lang, classes)
        if old_attr_naming(lang)
          # attribute name is without '_de'
          @builder.text_area(attribute_name, input_html_options.merge(:class => classes))
        else
          @builder.text_area("#{attribute_name}_#{lang}", input_html_options.merge(:class => classes))
        end
      end
    end
  end
end
