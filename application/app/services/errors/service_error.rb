module Errors
  class ServiceError < StandardError
    attr_reader :errors, :params

    def initialize(errors:, params: {})
      super
      @errors = errors
      @params = params
    end
  end
end
