# frozen_string_literal: true

module InnerPerformance
  module ApplicationHelper
    include Pagy::Frontend

    # Based on https://stackoverflow.com/a/45428183/552936 and
    # https://datadome.co/learning-center/how-to-reduce-server-response-time/
    def row_class_from_duration(duration)
      medium_duration_range = InnerPerformance.configuration.medium_duration_range

      if duration.between?(medium_duration_range[0], medium_duration_range[1])
        "text-warning"
      elsif duration >= medium_duration_range[1]
        "text-danger"
      end
    end
  end
end
