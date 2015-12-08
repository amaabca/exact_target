require 'spec_helper'

describe ExactTarget::Subscriber do
  describe 'sign_up_for_vehicle_reminder?' do
    let(:subscriber) { ExactTarget::Subscriber.new(personal_vehicle_reminder: personal_vehicle_reminder,
                                                   business_vehicle_reminder: business_vehicle_reminder,
                                                   associate_vehicle_reminder: associate_vehicle_reminder) }

    subject { subscriber.sign_up_for_vehicle_reminder? }

    context 'last name set' do
      let(:personal_vehicle_reminder) { 'not blank' }
      let(:business_vehicle_reminder) { '' }
      let(:associate_vehicle_reminder) { '' }

      it { is_expected.to be_truthy }
    end

    context 'associated last name set' do
      let(:personal_vehicle_reminder) { '' }
      let(:business_vehicle_reminder) { '' }
      let(:associate_vehicle_reminder) { 'not blank' }

      it { is_expected.to be_truthy }
    end

    context 'business name set' do
      let(:personal_vehicle_reminder) { '' }
      let(:business_vehicle_reminder) { 'not blank' }
      let(:associate_vehicle_reminder) { '' }

      it { is_expected.to be_truthy }
    end

    context 'none set' do
      let(:personal_vehicle_reminder) { '' }
      let(:business_vehicle_reminder) { '' }
      let(:associate_vehicle_reminder) { '' }

      it { is_expected.to be_falsey }
    end
  end
end
