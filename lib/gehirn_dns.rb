require "gehirn_dns/version"
require "net/https"
require "json"

module GehirnDNS
  ENDPOINT = "https://api.gis.gehirn.jp/dns/v1/"

  def self.zones token, secret
    endpoint = URI.join(ENDPOINT, "zones")
    res = Net::HTTP.start(endpoint.host, endpoint.port, use_ssl: true) do |http|
      req = Net::HTTP::Get.new endpoint
      req.basic_auth(token, secret)
      http.request req
    end
    json = JSON[res.body]
    json.map do |js|
      GehirnDNS::Zone.new js
    end
  end

  class Zone
    attr_reader :id, :name, :version

    def initialize zone
      @id      = zone["id"]
      @name    = zone["name"]
      @version = zone["current_version_id"]
    end
  end
end
