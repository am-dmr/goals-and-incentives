class DeviseUnauthorized < Devise::FailureApp
  def respond
    self.status = 401
  end
end
