# frozen_string_literal: true

FactoryBot.define do
  factory :event, class: 'InnerPerformance::Event' do
    name { 'x' }
  end
end
