require 'crack'
require 'hashie'

module ExactTarget
  class SubscriptionManager
    def find(email)
      response = crackie_hash(ExactTarget::Api.new.find_subscriber(prepare_request(email)))
      ExactTarget::Subscriber.new(response.exacttarget.system.subscriber)
    end

    def create(email, subscriber)
      ExactTarget::Api.new.add_subscriber(prepare_request(email, subscriber.attributes))
      find(email)
    end

    def update(email, subscriber)
      return self.create(email, subscriber) if subscriber.new_record
      ExactTarget::Api.new.edit_subscriber(prepare_request(email, subscriber.attributes))
      find(email)
    end

    private
    def prepare_request(email, params = {})
      { email: email, attributes: params }
    end

    def crackie_hash(xml)
      Hashie::Mash.new(Crack::XML.parse(xml))
    end
  end
end
