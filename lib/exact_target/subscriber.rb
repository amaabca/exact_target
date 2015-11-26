require 'active_record'

module ExactTarget
  class Subscriber
    include ActiveModel::Model
    include ActiveRecord::AttributeAssignment

    attr_accessor :email, :travel_weekly, :enews, :travel_especials, :ins_enews, :deals_discounts, :fleet_contact,
                  :personal_vehicle_reminder, :business_vehicle_reminder, :associate_vehicle_reminder

    def save
      SubscriptionManager.new.save(self)
    end
  end
end
