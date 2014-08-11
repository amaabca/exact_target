describe ExactTarget::Api do
  let(:find_subscriber_successful_response) do
    OpenStruct.new({
      response: File.read(File.join("spec", "fixtures", "find_subscriber_successful_response.xml")),
      code: 200})
  end
  let(:find_subscriber_unsuccessful_response) do
    OpenStruct.new({
      response: File.read(File.join("spec", "fixtures", "find_subscriber_unsuccessful_response.xml")),
      code: 200})
  end
  let(:edit_subscriber_successful_response) do
    OpenStruct.new({
      response: File.read(File.join("spec", "fixtures", "edit_subscriber_successful_response.xml")),
      code: 200})
  end
  let(:edit_subscriber_unsuccessful_response) do
    OpenStruct.new({
      response: File.read(File.join("spec", "fixtures", "edit_subscriber_unsuccessful_response.xml")),
      code: 200})
  end
  let(:add_subscriber_successful_response) do
    OpenStruct.new({
      response: File.read(File.join("spec", "fixtures", "add_subscriber_successful_response.xml")),
      code: 200})
  end
  let(:add_subscriber_unsuccessful_response) do
    OpenStruct.new({
      response: File.read(File.join("spec", "fixtures", "add_subscriber_unsuccessful_response.xml")),
      code: 200})
  end

  let(:params_class) { Params.new }

  let(:default_configuration) do
    OpenStruct.new(
      endpoint = "Secret_Society_of_Super_Villains_Endpoint",
      username = "Edward_Nigma",
      password = "Nygma",
      list_id = "666")
  end

  let(:exact_target) { ExactTarget::Api.new }

  describe "#add_subscriber" do
    context "successful response" do
      before(:each) do
        RestClient.stub(:post).and_return(add_subscriber_successful_response)
      end

      it "returns success code" do
        response = exact_target.add_subscriber(params_class.add_params)
        expect(response.code).to eq(200)
      end

      it "return a success message" do
        response = exact_target.add_subscriber(params_class.add_params)
        doc = Nokogiri::XML response.response
        expect(doc.xpath("//subscriber/subscriber_info").text).to include("Subscriber was added/updated successfully")
      end
    end

    context "unsuccessful response" do
      before(:each) do
        RestClient.stub(:post).and_return(add_subscriber_unsuccessful_response)
      end

      it "return an error message" do
        params = params_class.add_params
        response = exact_target.add_subscriber(params_class.add_params)
        doc = Nokogiri::XML response.response
        expect(doc.xpath("//subscriber/error_description").text).to include("The subscriber already exists in the list")
      end
    end
  end

  describe "#find_subscriber" do
    context "successful response" do
      before(:each) do
        RestClient.stub(:post).and_return(find_subscriber_successful_response)
      end

      it "returns success code" do
        params = { email: "bruce_wayne@example.com", attributes: {}}
        response = exact_target.find_subscriber(params)
        expect(response.code).to eq(200)
      end

      it "returns the right subscriber" do
        params = { email: "bruce_wayne@example.com", attributes: {}}
        response = exact_target.find_subscriber(params)
        doc = Nokogiri::XML response.response
        expect(doc.xpath("//subscriber/Email__Address").text).to eq params[:email]
      end
    end

    context "unsuccessful response" do
      before(:each) do
        RestClient.stub(:post).and_return(find_subscriber_unsuccessful_response)
      end

      it "returns error message including list_id and email" do
        params = { email: "batman@exmaple.com", attributes: {}}
        response = exact_target.find_subscriber(params)
        doc = Nokogiri::XML response.response
        expect(doc.xpath("//subscriber/error_description").text).to include(params[:email])
      end
    end
  end

  describe "#edit_subscriber" do
    context "successful response" do
      before(:each) do
        RestClient.stub(:post).and_return(edit_subscriber_successful_response)
      end

      it "return a success message" do
        response = exact_target.edit_subscriber(params_class.edit_params)
        doc = Nokogiri::XML response.response
        expect(doc.xpath("//subscriber/subscriber_info").text).to include("Subscriber was added/updated successfully")
      end
    end

    context "unsuccessful response" do
      before(:each) do
        RestClient.stub(:post).and_return(edit_subscriber_unsuccessful_response)
      end

      it "return an error message" do
        params = params_class.edit_params
        params[:attributes] = nil
        response = exact_target.edit_subscriber(params_class.edit_params)
        doc = Nokogiri::XML response.response
        expect(doc.xpath("//subscriber/error-description").text).to include("No attributes provided")
      end
    end
  end
end