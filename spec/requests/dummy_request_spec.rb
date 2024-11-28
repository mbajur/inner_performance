# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Dummy request", type: :request) do
  before do
    InnerPerformance.configuration.sample_rates = {
      "process_action.action_controller" => 100,
      "perform.active_job" => 100,
    }
  end

  describe "GET /" do
    subject do
      get "/dummy"
      response
    end

    it "returns a successfull response" do
      expect(subject).to(have_http_status(:ok))
    end

    it "enqueues InnerPerformance::SaveEventJob" do
      subject
      expect(InnerPerformance::SaveEventJob).to(
        have_been_enqueued.with(
          hash_including(
            type: "InnerPerformance::Events::ProcessActionActionController",
            event: "process_action.action_controller",
            name: "ApplicationController#dummy",
          ),
        ),
      )
    end
  end
end
