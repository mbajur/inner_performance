# frozen_string_literal: true

require "rails_helper"

describe DummyJob do
  it "enqueues InnerPerformance::SaveEventJob" do
    described_class.perform_now

    expect(InnerPerformance::SaveEventJob).to(
      have_been_enqueued.with(
        hash_including(
          type: "InnerPerformance::Events::PerformActiveJob",
          event: "perform.active_job",
          name: "DummyJob",
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
      described_class.perform_now

      expect(InnerPerformance::SaveEventJob).to(
        have_been_enqueued.with(
          hash_including(
            type: "InnerPerformance::Events::PerformActiveJob",
            event: "perform.active_job",
            name: "DummyJob",
          ),
        ),
      )

      traces = ActiveJob::Base.queue_adapter.enqueued_jobs.last[:args][0]['traces']
      expect(traces.size).to(eq(2))

      identifiers = traces.map do |trace|
        trace.dig('payload', 'identifier') || trace.dig('payload', 'sql')
      end.to_a

      expect(identifiers).to(include("SELECT \"inner_performance_events\".* FROM \"inner_performance_events\"").once)
      expect(identifiers).to(include("SELECT \"inner_performance_traces\".* FROM \"inner_performance_traces\"").once)
    end
  end
end
