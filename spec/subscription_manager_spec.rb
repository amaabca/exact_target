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

  describe 'add subscription' do
    let(:email) { 'bruce_wayne@example.com' }
    let(:enews) { '1' }
    let(:travel_especials) { '0' }
    let(:travel_weekly) { '1' }
    let(:deals_discounts) { '0' }
    let(:personal_vehicle_reminder) { 'last name' }
    let(:business_vehicle_reminder) { 'business name' }
    let(:associate_vehicle_reminder) { 'other name' }
    let(:fleet_contact) { '1' }

    it 'sends params with new record true' do
      expect_any_instance_of(ExactTarget::Api).to receive(:add_subscriber).with(
          {
              email: email,
              attributes: {
                  new_record: true,
                  AMA__eNEWS: enews,
                  AMA__TRAVEL__eSpecials: travel_especials,
                  AMA__TRAVEL__Weekly: travel_weekly,
                  amadealsdiscounts: deals_discounts,
                  personal_vehicle_reminder: personal_vehicle_reminder,
                  business_vehicle_reminder: business_vehicle_reminder,
                  associate_vehicle_reminder: associate_vehicle_reminder,
                  fleet_contact: fleet_contact,
                  email__address: email }
          }
      )

      subscriber = ExactTarget::Subscriber.new({ email: email, enews: enews, travel_especials: travel_especials,
                                                 travel_weekly: travel_weekly, deals_discounts: deals_discounts,
                                                 personal_vehicle_reminder: personal_vehicle_reminder,
                                                 business_vehicle_reminder: business_vehicle_reminder,
                                                 associate_vehicle_reminder: associate_vehicle_reminder,
                                                 fleet_contact: fleet_contact })

      ExactTarget::SubscriptionManager.new.create(subscriber)

    end
  end
end
