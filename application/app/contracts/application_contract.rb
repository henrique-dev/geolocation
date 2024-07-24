class ApplicationContract < Dry::Validation::Contract
  def self.call(args = nil)
    contract = new.call(args)

    return contract.to_h if contract.success?

    raise Errors::ServiceError.new(errors: contract.errors.to_h)
  end
end
