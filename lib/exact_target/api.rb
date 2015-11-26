module ExactTarget
  class Api
    def find_subscriber(params = {})
      send_request(params, 'find_subscriber.xml.erb')
    end

    def add_subscriber(params = {})
      send_request(params, 'add_subscriber.xml.erb')
    end

    def edit_subscriber(params = {})
      send_request(params, 'edit_subscriber.xml.erb')
    end

    def remove_subscriber(params = {})
      send_request(params, 'remove_subscriber.xml.erb')
    end

    def trigger_email(params = {})
      send_request(params, 'trigger_email.xml.erb')
    end

  private
    def set_attributes(params)
      params[:attributes] = params.fetch(:attributes, {})
      @params = params
    end

    def send_request(params, template)
      set_attributes(params)
      template = File.read(File.join(File.dirname(__FILE__), "templates", "#{template}")).to_s
      xml = ERB.new(template).result(binding)
      RestClient.post(ExactTarget.configuration.endpoint, { qf: :xml, xml: xml })
    end
  end
end
