# frozen_string_literal: true

require "rails_helper"

describe InnerPerformance::Traces::Db do
  describe ".initialize_for_insert" do
    subject { described_class.initialize_for_insert(trace: trace, event: event) }

    let(:trace) do
      {
        name: "sql.active_record",
        payload: { sql: "foo" },
        duration: 123,
        time: Time.current,
      }
    end

    let(:event) { create(:event) }

    it "returns a hash with the correct keys and values" do
      expect(subject).to(eq({
        type: "InnerPerformance::Traces::Db",
        name: "sql.active_record",
        payload: { sql: "foo" }.to_json,
        duration: 123,
        created_at: trace[:time],
        event_id: event.id,
      }))
    end
  end
end
