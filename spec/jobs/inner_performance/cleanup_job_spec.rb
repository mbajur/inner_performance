# frozen_string_literal: true

require "rails_helper"

describe InnerPerformance::CleanupJob do
  subject { described_class.perform_now }

  let!(:old_event) { create(:event, created_at: 7.days.ago) }
  let!(:fresh_event) { create(:event, created_at: 6.days.ago) }

  it "removes jobs older than InnerPerformance.configuration.events_retention" do
    expect { subject }.to(change(InnerPerformance::Event.all, :count).by(-1))
  end
end
