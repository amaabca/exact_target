module ExactTarget
  class Subscriber
    # include ActiveModel::Validations
    # include ActiveModel::Conversion
    # extend ActiveModel::Naming

    attr_accessor :new_record, :email__address, :AMA__TRAVEL__Weekly, :AMA__eNEWS, :AMA__TRAVEL__eSpecials, :AMA__INS__ENEWS,
                  :amadealsdiscounts, :fleet_contact
    attr_accessor :personal_vehicle_reminder, :business_vehicle_reminder, :associate_vehicle_reminder
    alias_attribute :email, :email__address

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
    end

    def attributes=(atts = {})
      atts.each_pair do |k, v|
        public_send("#{k}=", v) if respond_to?(k)
      end
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

    def attributes
      Hash.new.tap do |atts|
        instance_variables.each { |att| atts[att.to_s.delete("@").to_sym] = instance_variable_get(att) }
      end
    end

    def persisted?
      false
    end
  end
end
