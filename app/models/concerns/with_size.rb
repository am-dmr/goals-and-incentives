module WithSize
  extend ActiveSupport::Concern

  class_methods do
    def sizes_for_select
      sizes.each_with_object({}) { |(k, _), h| h[k.to_s.upcase] = k }
    end
  end

  included do
    enum size: {
      xs: 1,
      s: 2,
      m: 3,
      l: 4,
      xl: 5,
      xxl: 6,
      xxxl: 7
    }, _prefix: :size

    validates :size, presence: true

    def size_humanize
      size.to_s.upcase
    end
  end
end
