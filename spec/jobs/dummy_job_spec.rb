# frozen_string_literal: true

require 'rails_helper'

describe DummyJob do
  it 'enqueues InnerPerformance::SaveEventJob' do
    described_class.perform_now

    expect(InnerPerformance::SaveEventJob).to(
      have_been_enqueued.with(
        hash_including(
          type: 'InnerPerformance::Events::PerformActiveJob',
          event: 'perform.active_job',
          name: 'DummyJob'
        )
      )
    )
  end
end
