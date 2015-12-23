module ExactTarget
  class SubscriptionManager
    def find(email)
      response = crackie_hash(ExactTarget::Api.new.find_subscriber({ email: email }))
      build_subscription(email, response.exacttarget.system.subscriber)
    end

    def save(subscriber)
      if exists?(subscriber.email)
        ExactTarget::Api.new.edit_subscriber(prepare_request(subscriber))
      else
        ExactTarget::Api.new.add_subscriber(prepare_request(subscriber, true))
      end
      find(subscriber.email)
    end

  private

    def exists?(email)
      response = crackie_hash(ExactTarget::Api.new.find_subscriber({ email: email }))
      response.exacttarget.system.subscriber[:error].nil?
    end

    def prepare_request(subscriber, new_record = false)
      {
          email: subscriber.email,
          attributes: {
              new_record: new_record,
              AMA__eNEWS: subscriber.enews,
              AMA__TRAVEL__eSpecials: subscriber.travel_especials,
              AMA__TRAVEL__Weekly: subscriber.travel_weekly,
              AMA__INS__ENEWS: subscriber.ins_enews,
              amadealsdiscounts: subscriber.deals_discounts,
              New__Member__Series: subscriber.new_member_series,
              personal_vehicle_reminder: subscriber.personal_vehicle_reminder,
              business_vehicle_reminder: subscriber.business_vehicle_reminder,
              associate_vehicle_reminder: subscriber.associate_vehicle_reminder,
              fleet_contact: subscriber.fleet_contact,
              email__address: subscriber.email }
      }
    end

    def build_subscription(email, args)
      if args && args[:error].nil?
        params = { email: args[:Email__Address],
                   travel_weekly: args[:AMA__TRAVEL__Weekly],
                   enews: args[:AMA__eNEWS],
                   travel_especials: args[:AMA__TRAVEL__eSpecials],
                   ins_enews: args[:AMA__INS__ENEWS],
                   deals_discounts: args[:amadealsdiscounts],
                   fleet_contact: args[:fleet_contact],
                   new_member_series: args[:New__Member__Series],
                   personal_vehicle_reminder: args[:personal_vehicle_reminder],
                   business_vehicle_reminder: args[:business_vehicle_reminder],
                   associate_vehicle_reminder: args[:associate_vehicle_reminder] }
      else
        params = { email: email }
      end

      ExactTarget::Subscriber.new(params)
    end

    def crackie_hash(xml)
      Hashie::Mash.new(Crack::XML.parse(xml))
    end
  end
end
