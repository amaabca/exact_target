module ExactTarget
  class Api
    def find_subscriber(params = {})
      set_attributes(params)
      send_request('find_subscriber.xml.erb')
    end

    def add_subscriber(params = {})
      set_attributes(params)
      send_request('add_subscriber.xml.erb')
    end

    def edit_subscriber(params = {})
      set_attributes(params)
      send_request('edit_subscriber.xml.erb')
    end

    def remove_subscriber(params = {})
      set_attributes(params)
      send_request('remove_subscriber.xml.erb')
    end

    def trigger_email(params = {})
      set_attributes(params)
      send_request('trigger_email.xml.erb')
    end

  private
    def set_attributes(params)
      params[:attributes] = params.fetch(:attributes, {})
      @params = params
    end

    def send_request(template)
      template = File.read(File.join(File.dirname(__FILE__), "templates", "#{template}")).to_s
      xml = ERB.new(template).result(binding)
      RestClient.post(ExactTarget.configuration.endpoint, { qf: :xml, xml: xml })
    end
  end
end