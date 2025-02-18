# frozen_string_literal: true

require "rails_helper"

describe InnerPerformance::CleanupJob do
  subject { described_class.perform_now }

  let!(:old_event) { create(:event, created_at: 7.days.ago) }
  let!(:fresh_event) { create(:event, created_at: 6.days.ago) }

  let!(:old_trace) { create(:trace, event: old_event, created_at: 7.days.ago) }
  let!(:fresh_trace) { create(:trace, event: fresh_event, created_at: 6.days.ago) }

  it "removes events older than InnerPerformance.configuration.events_retention" do
    expect { subject }.to(change(InnerPerformance::Event.all, :count).by(-1))
    expect(InnerPerformance::Event.all).to(eq([fresh_event]))
  end

  it "removes traces older than InnerPerformance.configuration.events_retention" do
    expect { subject }.to(change(InnerPerformance::Trace.all, :count).by(-1))
    expect(InnerPerformance::Trace.all).to(eq([fresh_trace]))
  end
end
