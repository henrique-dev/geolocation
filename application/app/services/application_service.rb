class ApplicationService
  def self.call(args = nil)
    if args.nil?
      new.call
    elsif args.is_a?(Hash)
      new(**args).call(**args)
    else
      new.call(args)
    end
  end

  def initialize(_args = nil)
    super()

    @service_object ||= ServiceResponse.new
  end

  def with_service_handler
    return @service_object unless block_given?

    new_object = yield(@service_object.object)
    @service_object.object ||= new_object

    @service_object
  rescue Errors::ServiceError => e
    if Rails.env == 'development'
      puts 'rescue from: with_service_handler'.red
      puts e.message
      ap e.backtrace
    end

    @service_object.success = false
    @service_object.errors.merge!(e.errors)
    @service_object.object = nil
    @service_object
  end

  private

  def validate_object(object = nil)
    @service_object.success = true
    @service_object.object = object

    object
  end
end
