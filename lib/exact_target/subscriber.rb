module ExactTarget
  class Subscriber
    attr_accessor :personal_vehicle_reminder, :business_vehicle_reminder, :associate_vehicle_reminder
    attr_accessor :email, :travel_weekly, :enews, :travel_especials, :ins_enews, :deals_discounts, :fleet_contact,
                  :personal_vehicle_reminder, :business_vehicle_reminder, :associate_vehicle_reminder

    def initialize(args = {})
      self.email = args[:Email__Address]
      self.travel_weekly = args[:AMA__TRAVEL__Weekly]
      self.enews = args[:AMA__eNEWS]
      self.travel_especials = args[:AMA__TRAVEL__eSpecials]
      self.ins_enews = args[:AMA__INS__ENEWS]
      self.deals_discounts = args[:amadealsdiscounts]
      self.fleet_contact = args[:fleet_contact]
      self.personal_vehicle_reminder = args[:personal_vehicle_reminder]
      self.business_vehicle_reminder = args[:business_vehicle_reminder]
      self.associate_vehicle_reminder = args[:associate_vehicle_reminder]
    end

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
