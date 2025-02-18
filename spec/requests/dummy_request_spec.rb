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
            traces: []
          ),
        ),
      )
    end

    context "when traces_enabled is set to true" do
      before do
        InnerPerformance.configuration.traces_enabled = true
      end

      it "enqueues InnerPerformance::SaveEventJob with traces" do
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

        traces = enqueued_jobs.last[:args][0]['traces']
        expect(traces.size).to(eq(4))

        identifiers = traces.map do |trace|
          trace.dig('payload', 'identifier') || trace.dig('payload', 'sql')
        end.to_a

        expect(identifiers).to(include("SELECT COUNT(*) FROM \"inner_performance_events\"").once)
        expect(identifiers).to(include("SELECT COUNT(*) FROM \"inner_performance_traces\"").once)
        expect(identifiers).to(include(/app\/views\/application\/_dummy_partial.html.erb/).once)
        expect(identifiers).to(include(/app\/views\/application\/dummy.html.erb/).once)
      end
    end
  end
end
