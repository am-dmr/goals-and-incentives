module WithEnum
  extend ActiveSupport::Concern

  class_methods do
    def enum_display(enum_attr, value)
      human_attribute_name([enum_attr, value].join('/'))
    end

    def enum_options_for_select(enum_attr)
      public_send(enum_attr.to_s.pluralize).map do |k, _|
        [enum_display(enum_attr, k), k]
      end
    end
  end

  included do
    def enum_display(enum_attr)
      self.class.enum_display(enum_attr, public_send(enum_attr))
    end
  end
end
