require 'crack'
require 'hashie'

module ExactTarget
  class SubscriptionManager
    def find(email)
      response = crackie_hash(ExactTarget::Api.new.find_subscriber({ email: email }))
      build_subscription(response.exacttarget.system.subscriber)
    end

    def create(subscriber)
      ExactTarget::Api.new.add_subscriber(prepare_request(subscriber, true))
      find(subscriber.email)
    end

    def update(email, subscriber)
      return self.create(subscriber) if subscriber.new_record
      ExactTarget::Api.new.edit_subscriber(prepare_request(subscriber))
      find(email)
    end

    def build_subscription(args)
      params = { email: args[:Email__Address],
                 travel_weekly: args[:AMA__TRAVEL__Weekly],
                 enews: args[:AMA__eNEWS],
                 travel_especials: args[:AMA__TRAVEL__eSpecials],
                 ins_enews: args[:AMA__INS__ENEWS],
                 deals_discounts: args[:amadealsdiscounts],
                 fleet_contact: args[:fleet_contact],
                 personal_vehicle_reminder: args[:personal_vehicle_reminder],
                 business_vehicle_reminder: args[:business_vehicle_reminder],
                 associate_vehicle_reminder: args[:associate_vehicle_reminder] }

      ExactTarget::Subscriber.new(params)
    end

    private
    def prepare_request(subscriber, new_record = false)
      {
          email: subscriber.email,
          attributes: {
              new_record: new_record,
              AMA__eNEWS: subscriber.enews,
              AMA__TRAVEL__eSpecials: subscriber.travel_especials,
              AMA__TRAVEL__Weekly: subscriber.travel_weekly,
              amadealsdiscounts: subscriber.deals_discounts,
              personal_vehicle_reminder: subscriber.personal_vehicle_reminder,
              business_vehicle_reminder: subscriber.business_vehicle_reminder,
              associate_vehicle_reminder: subscriber.associate_vehicle_reminder,
              fleet_contact: subscriber.fleet_contact,
              email__address: subscriber.email }
      }
    end

    def crackie_hash(xml)
      Hashie::Mash.new(Crack::XML.parse(xml))
    end
  end
end
