module WithSize
  extend ActiveSupport::Concern

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
  end
end
