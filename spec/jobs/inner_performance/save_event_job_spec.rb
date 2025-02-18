# frozen_string_literal: true

require "rails_helper"

describe InnerPerformance::SaveEventJob do
  subject { described_class.perform_now(**args) }

  let(:args) do
    {
      type: InnerPerformance::Events::PerformActiveJob.name,
      created_at: Time.current,
      event: "perform.active_job",
      name: "DummyJob",
      duration: 100,
      db_runtime: 79,
      properties: {
        foo: "bar",
      },
      traces: [
        {
          group: :db,
          name: "sql.active_record",
          payload: { sql: "SELECT * FROM foo" },
          duration: 10,
          time: Time.current,
        },
        {
          group: :view,
          name: "render_template.action_view",
          payload: { identifier: "foo" },
          duration: 20,
          time: Time.current,
        },
      ],
    }
  end

  it "saves event" do
    expect { subject }.to(change(InnerPerformance::Event.all, :count).by(1))

    event = InnerPerformance::Event.last
    expect(event.type).to(eq("InnerPerformance::Events::PerformActiveJob"))
    expect(event.event).to(eq("perform.active_job"))
    expect(event.duration).to(eq(100))
    expect(event.db_runtime).to(eq(79))
    expect(event.properties).to(eq("foo" => "bar"))
  end

  context "when traces_enabled is true" do
    around(:example) do |ex|
      traces_enabled = InnerPerformance.configuration.traces_enabled
      InnerPerformance.configuration.traces_enabled = true
      ex.run
      InnerPerformance.configuration.traces_enabled = traces_enabled
    end

    it "saves traces" do
      expect { subject }.to(change(InnerPerformance::Trace.all, :count).by(2))
    end
  end

  context "when cleanup_immediately is true" do
    before { InnerPerformance.configuration.cleanup_immediately = true }

    it "enqueues CleanupJob" do
      expect(InnerPerformance::CleanupJob).to(receive(:perform_later))
      subject
    end
  end

  context "when cleanup_immediately is false" do
    before { InnerPerformance.configuration.cleanup_immediately = false }

    it "does not enqueue CleanupJob" do
      expect(InnerPerformance::CleanupJob).not_to(receive(:perform_later))
    end
  end
end
