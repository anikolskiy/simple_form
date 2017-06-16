module SimpleForm
  module Inputs
    class LocalizedInput < Base
      enable :placeholder, :maxlength, :pattern

      LANGUAGES = [:de, :en, :ru]

      def self.supported_languages=(languages)
        @@languages = languages.map(&:to_sym)
      end

      def self.supported_languages
        defined?(@@languages) ? @@languages : LANGUAGES
      end

      def label
        if generate_label_for_attribute?
          @builder.label(label_target, label_text, label_html_options)
        else
          template.label_tag(nil, label_text, label_html_options)
        end
      end

      def language_switchers
        switchers = effective_languages.map do |lang|
          classes = ["LanguageSelector-link is-#{lang}"]
          classes << 'is-selected' if lang == supported_languages.first

          @builder.content_tag(:a, nil, :class => classes.join(' '), :href => '#', :data => { :lang => lang })
        end

        @builder.content_tag(:div, switchers.join.html_safe, :class => 'LanguageSwitchers')
      end

      def input
        input_html_options[:type] ||= 'text' unless string?
        add_size!

        orig_classes = [input_html_options[:class], 'js-localized'].flatten

        effective_languages.map do |lang|
          classes = orig_classes.dup
          classes << 'hidden' unless lang == supported_languages.first
          classes << "lang_#{lang}"

          generate_input lang, classes.join(' ')
        end.join.html_safe
      end

      private

      def supported_languages
        SimpleForm::Inputs::LocalizedInput.supported_languages
      end

      def effective_languages
        supported_languages.select { |lang| lang == :de or has_attribute?("#{attribute_name}_#{lang}") }
      end

      def string?
        input_type == :string
      end

      def old_attr_naming(lang)
        lang.to_s == 'de' and !has_attribute?("#{attribute_name}_#{lang}") and has_attribute?(attribute_name)
      end

      def has_attribute?(attr)
        @builder.object.attributes.keys.include?(attr.to_s)
      end
    end
  end
end
