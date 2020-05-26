module WithEnum
  extend ActiveSupport::Concern

  included do |base|
    base.class_eval do
      base.attribute_types.select { |_, v| v.is_a?(ActiveRecord::Enum::EnumType) }.each_key do |enum_attr|
        define_singleton_method("display_#{enum_attr}") do |value|
          base.human_attribute_name([enum_attr, value].join('/'))
        end

        define_method("display_#{enum_attr}") do
          self.class.public_send("display_#{enum_attr}", public_send(enum_attr))
        end

        define_singleton_method("#{enum_attr}_options_for_select") do
          base.public_send(enum_attr.to_s.pluralize).map do |k, _|
            [base.public_send("display_#{enum_attr}", k), k]
          end
        end
      end
    end
  end
end
