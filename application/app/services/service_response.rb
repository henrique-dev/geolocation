class ServiceResponse
  attr_accessor :success, :object, :errors

  def initialize(success: true, object: nil, errors: {})
    @success = success
    @object = object
    @errors = errors
  end

  def with
    yield(success, object, errors)
  end
end
