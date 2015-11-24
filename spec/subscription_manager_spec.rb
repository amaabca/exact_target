require 'spec_helper'

describe ExactTarget::SubscriptionManager do
  before do
    ExactTarget.configure do |c|
      c.endpoint = 'test_url'
      c.username = 'test'
      c.password = 'test_pw'
      c.list_id = '123'
    end
  end

  describe 'find subscription by email' do
    let(:find_subscriber_successful_response) {
      File.read(File.join('spec', 'fixtures', 'find_subscriber_successful_response.xml'))
    }

    before(:each) do
      WebMock::API.stub_request(:post, 'http://test_url/').to_return(body: find_subscriber_successful_response, status: 200)
    end

    it 'parses subscription attributes' do
      subscription = ExactTarget::SubscriptionManager.new.find('bruce_wayne@example.com')

      expect(subscription.email).to eq 'bruce_wayne@example.com'
      expect(subscription.deals_discounts).to eq '0'
      expect(subscription.ins_enews).to eq '1'
      expect(subscription.enews).to eq '0'
      expect(subscription.travel_especials).to eq '1'
      expect(subscription.travel_weekly).to eq '1'
      expect(subscription.personal_vehicle_reminder).to eq 'Estevez'
      expect(subscription.business_vehicle_reminder).to eq 'My Company'
      expect(subscription.associate_vehicle_reminder).to eq 'Additional Last Name'
    end
  end
end
