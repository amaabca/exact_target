module ExactTarget

  attr_accessor :configuration

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  class Configuration
    attr_accessor :endpoint, :username, :password, :list_id

    def initialize
      self.endpoint = ""
      self.username = ""
      self.password = ""
      self.list_id = ""
    end
  end
end