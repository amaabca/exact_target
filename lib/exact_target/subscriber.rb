module ExactTarget
  class Subscriber
    include ActiveModel::Model
    include ActiveRecord::AttributeAssignment

    attr_accessor :email, :travel_weekly, :enews, :travel_especials, :ins_enews, :deals_discounts, :fleet_contact,
                  :new_member_series, :personal_vehicle_reminder, :business_vehicle_reminder, :associate_vehicle_reminder

    def save
      SubscriptionManager.new.save(self)
    end

    def sign_up_for_vehicle_reminder?
      personal_vehicle_reminder.present? || business_vehicle_reminder.present? || associate_vehicle_reminder.present?
    end
  end
end
