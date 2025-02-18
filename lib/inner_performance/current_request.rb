# Heavily based on RailsPerformance implementation:
# https://github.com/igorkasyanchuk/rails_performance/blob/master/lib/rails_performance/thread/current_request.rb
module InnerPerformance
  class CurrentRequest
    attr_reader :request_id, :traces, :ignore
    attr_accessor :data
    attr_accessor :record

    def self.init
      Thread.current[:ip_current_request] ||= CurrentRequest.new(SecureRandom.hex(16))
    end

    def self.current
      CurrentRequest.init
    end

    def self.cleanup
      Thread.current[:ip_current_request] = nil
    end

    def initialize(request_id)
      @request_id = request_id
      @traces = []
      @ignore = Set.new
      @data = nil
      @record = nil
    end

    def trace(options = {})
      @traces << options.merge(time: Time.current.to_i)
    end
  end
end
