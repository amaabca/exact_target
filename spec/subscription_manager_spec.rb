require 'spec_helper'

describe ExactTarget::SubscriptionManager do
  before do
    ExactTarget.configure do |c|
      c.endpoint = 'testurl'
      c.username = 'test'
      c.password = 'test_pw'
      c.list_id = '123'
    end
  end

  let(:email) { 'bruce_wayne@example.com' }
  let(:enews) { '1' }
  let(:travel_especials) { '0' }
  let(:travel_weekly) { '1' }
  let(:deals_discounts) { '0' }
  let(:ins_enews) { '1' }
  let(:new_member_series) { '1' }
  let(:personal_vehicle_reminder) { 'last name' }
  let(:business_vehicle_reminder) { 'business name' }
  let(:associate_vehicle_reminder) { 'other name' }
  let(:fleet_contact) { '1' }

  let(:find_subscriber_successful_response) {
    File.read(File.join('spec', 'fixtures', 'find_subscriber_successful_response.xml'))
  }

  let(:find_subscriber_unsuccessful_response) {
    File.read(File.join('spec', 'fixtures', 'find_subscriber_unsuccessful_response.xml'))
  }

  describe 'find subscriber by email' do
    context 'subscriber found' do
      before(:each) do
        WebMock::API.stub_request(:post, 'http://testurl/').to_return(body: find_subscriber_successful_response, status: 200)
      end

      it 'parses subscription attributes' do
        subscription = ExactTarget::SubscriptionManager.new.find('bruce_wayne@example.com')

        expect(subscription.email).to eq 'bruce_wayne@example.com'
        expect(subscription.deals_discounts).to eq '0'
        expect(subscription.ins_enews).to eq '1'
        expect(subscription.enews).to eq '0'
        expect(subscription.travel_especials).to eq '1'
        expect(subscription.travel_weekly).to eq '1'
        expect(subscription.new_member_series).to eq '1'
        expect(subscription.personal_vehicle_reminder).to eq 'Estevez'
        expect(subscription.business_vehicle_reminder).to eq 'My Company'
        expect(subscription.associate_vehicle_reminder).to eq 'Additional Last Name'
      end
    end

    context 'subscriber not found' do
      before(:each) do
        WebMock::API.stub_request(:post, 'http://testurl/').to_return(body: find_subscriber_unsuccessful_response, status: 200)
      end

      it 'parses subscription attributes' do
        subscription = ExactTarget::SubscriptionManager.new.find('bruce_wayne@example.com')

        expect(subscription.email).to eq 'bruce_wayne@example.com'
        expect(subscription.deals_discounts).to eq nil
        expect(subscription.ins_enews).to eq nil
        expect(subscription.enews).to eq nil
        expect(subscription.travel_especials).to eq nil
        expect(subscription.travel_weekly).to eq nil
        expect(subscription.new_member_series).to eq nil
        expect(subscription.personal_vehicle_reminder).to eq nil
        expect(subscription.business_vehicle_reminder).to eq nil
        expect(subscription.associate_vehicle_reminder).to eq nil
      end
    end

    context 'exact target returns invalid response' do
      before(:each) do
        xml = "<exacttarget><system><subscriber></subscriber></system></exacttarget>"
        # expect(RestClient).to receive(:post).at_least(:once).and_return(xml)
        WebMock::API.stub_request(:post, 'http://testurl/').to_return(body: xml, status: 200)
      end

      it 'creates basic subscription model' do
        subscription = ExactTarget::SubscriptionManager.new.find('bruce_wayne@example.com')
        expect(subscription.email).to eq 'bruce_wayne@example.com'
      end
    end
  end

  describe 'exists' do
    context 'subscriber exists' do
      before(:each) do
        WebMock::API.stub_request(:post, 'http://testurl/').to_return(body: find_subscriber_successful_response, status: 200)
      end

      it 'returns true' do
        expect(ExactTarget::SubscriptionManager.new.send(:exists?, email)).to be_truthy
      end
    end

    context 'subscriber does not exist' do
      before(:each) do
        WebMock::API.stub_request(:post, 'http://testurl/').to_return(body: find_subscriber_unsuccessful_response, status: 200)
      end

      it 'returns false' do
        expect(ExactTarget::SubscriptionManager.new.send(:exists?, email)).to be_falsey
      end
    end
  end

  describe 'save subscription' do
    let(:subscriber) { ExactTarget::Subscriber.new({ email: email, enews: enews, travel_especials: travel_especials,
                                                     travel_weekly: travel_weekly, deals_discounts: deals_discounts,
                                                     ins_enews: ins_enews, new_member_series: new_member_series,
                                                     personal_vehicle_reminder: personal_vehicle_reminder,
                                                     business_vehicle_reminder: business_vehicle_reminder,
                                                     associate_vehicle_reminder: associate_vehicle_reminder,
                                                     fleet_contact: fleet_contact }) }
    context 'subscriber does not exist in exact target' do
      before do
        expect_any_instance_of(ExactTarget::SubscriptionManager).to receive(:exists?).and_return(false)
      end

      it 'sends params with new record true' do
        expect_any_instance_of(ExactTarget::Api).to receive(:add_subscriber).with(
            {
                email: email,
                attributes: {
                    new_record: true,
                    AMA__eNEWS: enews,
                    AMA__TRAVEL__eSpecials: travel_especials,
                    AMA__TRAVEL__Weekly: travel_weekly,
                    AMA__INS__ENEWS: ins_enews,
                    amadealsdiscounts: deals_discounts,
                    New__Member__Series: new_member_series,
                    personal_vehicle_reminder: personal_vehicle_reminder,
                    business_vehicle_reminder: business_vehicle_reminder,
                    associate_vehicle_reminder: associate_vehicle_reminder,
                    fleet_contact: fleet_contact,
                    email__address: email }
            }
        )
        ExactTarget::SubscriptionManager.new.save(subscriber)
      end
    end

    context 'subscriber already exists in exact target' do
      before do
        expect_any_instance_of(ExactTarget::SubscriptionManager).to receive(:exists?).and_return(true)
      end

      it 'sends params with new record true' do
        expect_any_instance_of(ExactTarget::Api).to receive(:edit_subscriber).with(
            {
                email: email,
                attributes: {
                    new_record: false,
                    AMA__eNEWS: enews,
                    AMA__TRAVEL__eSpecials: travel_especials,
                    AMA__TRAVEL__Weekly: travel_weekly,
                    AMA__INS__ENEWS: ins_enews,
                    amadealsdiscounts: deals_discounts,
                    New__Member__Series: new_member_series,
                    personal_vehicle_reminder: personal_vehicle_reminder,
                    business_vehicle_reminder: business_vehicle_reminder,
                    associate_vehicle_reminder: associate_vehicle_reminder,
                    fleet_contact: fleet_contact,
                    email__address: email }
            }
        )

        ExactTarget::SubscriptionManager.new.save(subscriber)
      end
    end
  end
end
