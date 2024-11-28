# frozen_string_literal: true

require "rails_helper"

describe InnerPerformance do
  describe ".save_event?" do
    subject { described_class.save_event?(event) }

    let(:event) do
      ActiveSupport::Notifications::Event.new(
        event_name,
        (Time.current - 1.minute).to_i,
        Time.current.to_i,
        "foo",
        event_payload,
      )
    end

    context "when event is perform.active_job" do
      let(:event_name) { "perform.active_job" }

      context "when job is InnerPerformance::SaveEventJob" do
        let(:event_payload) { { job: InnerPerformance::SaveEventJob.new } }

        it { is_expected.to(eq(false)) }
      end

      context "when job is DummyJob" do
        let(:event_payload) { { job: DummyJob.new } }

        it { is_expected.to(eq(true)) }

        context "when rand returned number bigger than sample rate" do
          before do
            allow_any_instance_of(Object).to(receive(:rand).with(100).and_return(101))
          end

          it { is_expected.to(eq(false)) }
        end
      end
    end
  end
end
