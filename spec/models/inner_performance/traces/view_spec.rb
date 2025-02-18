# frozen_string_literal: true

require "rails_helper"

describe InnerPerformance::Traces::View do
  describe ".initialize_for_insert" do
    subject { described_class.initialize_for_insert(trace: trace, event: event) }
    let!(:time) { Time.current }

    let(:trace) do
      {
        name: "render_template.action_view",
        payload: { identifier: "foo" },
        duration: 123,
        time: time,
      }
    end

    let(:event) { create(:event) }

    it "returns a hash with the correct keys and values" do
      expect(subject).to(eq({
        type: "InnerPerformance::Traces::View",
        name: "render_template.action_view",
        payload: { identifier: "foo" }.to_json,
        duration: 123,
        created_at: time,
        event_id: event.id,
      }))
    end
  end
end
