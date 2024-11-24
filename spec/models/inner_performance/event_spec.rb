# frozen_string_literal: true

require 'rails_helper'

describe InnerPerformance::Event do
  describe '.ransackable_attributes' do
    it 'defines ransackable attributes' do
      expect(described_class.ransackable_attributes).to eq %w[
        created_at db_runtime duration event format id name
      ]
    end
  end

  describe '.ransackable_associations' do
    it 'defines ransackable associations' do
      expect(described_class.ransackable_associations).to eq []
    end
  end
end
