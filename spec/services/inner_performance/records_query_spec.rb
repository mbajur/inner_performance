# frozen_string_literal: true

require "rails_helper"

describe InnerPerformance::RecordsQuery do
  subject(:query) do
    described_class.new(
      scope: InnerPerformance::Event.all,
      params: params,
      filterable_attributes: %w[name event],
      sortable_columns: %w[name duration db_runtime created_at],
      per_page: 2,
    )
  end

  let(:params) { ActionController::Parameters.new({}) }

  let!(:event_a) { create(:event, name: "HomeController#index", event: "process_action.action_controller", duration: 100) }
  let!(:event_b) { create(:event, name: "HomeController#index", event: "process_action.action_controller", duration: 200) }
  let!(:event_c) { create(:event, name: "DummyJob", event: "perform.active_job", duration: 50) }

  describe "#current_page" do
    context "when page param is missing" do
      it { expect(query.current_page).to(eq(1)) }
    end

    context "when page param is a positive integer" do
      let(:params) { ActionController::Parameters.new(page: "3") }

      it { expect(query.current_page).to(eq(3)) }
    end

    context "when page param is zero or negative" do
      let(:params) { ActionController::Parameters.new(page: "0") }

      it { expect(query.current_page).to(eq(1)) }
    end
  end

  describe "#sort_column" do
    context "when sort param is a valid column" do
      let(:params) { ActionController::Parameters.new(sort: "duration") }

      it { expect(query.sort_column).to(eq("duration")) }
    end

    context "when sort param is not in the allowed list" do
      let(:params) { ActionController::Parameters.new(sort: "arbitrary_column") }

      it { expect(query.sort_column).to(eq("created_at")) }
    end

    context "when sort param is missing" do
      it { expect(query.sort_column).to(eq("created_at")) }
    end
  end

  describe "#sort_direction" do
    context "when direction param is 'asc'" do
      let(:params) { ActionController::Parameters.new(direction: "asc") }

      it { expect(query.sort_direction).to(eq("asc")) }
    end

    context "when direction param is 'desc'" do
      let(:params) { ActionController::Parameters.new(direction: "desc") }

      it { expect(query.sort_direction).to(eq("desc")) }
    end

    context "when direction param is invalid" do
      let(:params) { ActionController::Parameters.new(direction: "sideways") }

      it { expect(query.sort_direction).to(eq("desc")) }
    end

    context "when direction param is missing" do
      it { expect(query.sort_direction).to(eq("desc")) }
    end
  end

  describe "#records" do
    context "with no filters" do
      it "returns all records up to per_page limit" do
        expect(query.records.size).to(eq(2))
      end
    end

    context "when filtering by name_eq" do
      let(:params) { ActionController::Parameters.new(q: { name_eq: "DummyJob" }) }

      it "returns only matching records" do
        expect(query.records).to(contain_exactly(event_c))
      end
    end

    context "when filtering by event_eq" do
      let(:params) { ActionController::Parameters.new(q: { event_eq: "process_action.action_controller" }) }

      it "returns only matching records" do
        expect(query.records).to(contain_exactly(event_a, event_b))
      end
    end

    context "when filtering by both name_eq and event_eq" do
      let(:params) do
        ActionController::Parameters.new(
          q: { name_eq: "HomeController#index", event_eq: "process_action.action_controller" },
        )
      end

      it "returns records matching all filters" do
        expect(query.records).to(contain_exactly(event_a, event_b))
      end
    end

    context "when filtering with a blank value" do
      let(:params) { ActionController::Parameters.new(q: { name_eq: "" }) }

      it "ignores the blank filter" do
        expect(query.records.size).to(eq(2))
      end
    end

    context "when sorting by duration asc" do
      let(:params) { ActionController::Parameters.new(sort: "duration", direction: "asc") }

      it "returns records in ascending duration order" do
        expect(query.records.to_a).to(eq([event_c, event_a]))
      end
    end

    context "when paginating to page 2" do
      let(:params) { ActionController::Parameters.new(page: "2", sort: "duration", direction: "asc") }

      it "returns the second page of results" do
        expect(query.records.to_a).to(eq([event_b]))
      end
    end
  end
end
