class BaseService
  extend Dry::Initializer

  def self.call(*args, &block)
    new(*args).call(&block)
  end
end
