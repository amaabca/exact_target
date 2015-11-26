require 'active_record'

module ExactTarget
  class Subscriber
    include ActiveModel::Model
    # include ActiveRecord::AttributeAssignment

    attr_accessor :email, :travel_weekly, :enews, :travel_especials, :ins_enews, :deals_discounts, :fleet_contact,
                  :personal_vehicle_reminder, :business_vehicle_reminder, :associate_vehicle_reminder

    def save
      return false unless valid?
      subscription_manager = SubscriptionManager.new
      subscription_manager.update(email, self)
    end

    def self.find(id)
      subscription_manager = SubscriptionManager.new
      subscription_manager.find(id)
    end
  end
end
