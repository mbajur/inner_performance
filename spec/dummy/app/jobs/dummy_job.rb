# frozen_string_literal: true

class DummyJob < ApplicationJob
  def perform
    true
  end
end
