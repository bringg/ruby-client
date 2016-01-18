require 'net/http'
require 'OpenSSL'
require 'json'
require 'date'
require 'cgi' unless defined?(CGI) && defined?(CGI::escape)

class Object
  def to_param
    to_s
  end
 def to_query(key)
    "#{CGI.escape(key.to_param)}=#{CGI.escape(to_param.to_s)}"
  end
end

class Hash
  def to_query(namespace=nil)
    collect do |key, value|
      unless (value.is_a?(Hash) || value.is_a?(Array)) && value.empty?
        value.to_query(namespace ? "#{namespace}[#{key}]" : key)
      end
    end.compact * '&'
  end
end

 class BringgClient
   def initialize(options = {})
    @options = options.dup
    @auth_token = options[:auth_token]
    @hmac_secret = options[:hmac_secret]
    @default_url = options[:url]
    @default_url ||= "http://api.bringg.com"
  end

  def create_customer(customer_details)
    uri = URI("#{@default_url}/partner_api/customers")
    params = customer_details
    Net::HTTP.post_form(uri, sign_request(params))
  end

  def create_task(task_deails)
    uri = URI("#{@default_url}/partner_api/tasks")
    req = Net::HTTP::Post.new(uri, initheader = {'Content-Type' =>'application/json'})
    req.body = sign_request(task_deails).to_json
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end
  end

  def add_waypoint(task_id, way_point_details)
    uri = URI("#{@default_url}/partner_api/tasks/#{task_id}/way_points/")
    params = way_point_details
    Net::HTTP.post_form(uri, sign_request(params))
  end

  def merchant_configuration(company_id, company_configuration)
    uri = URI("#{@default_url}/partner_api/companies/#{company_id}/company_configuration/")
    params = company_configuration

    req = Net::HTTP::Patch.new(uri, initheader = {'Content-Type' =>'application/json'})
    req.body = sign_request(params).to_json
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end
  end

  def delete_task(id)
    params = sign_request({})
    query_params = params.collect do |key,val|
      "#{CGI.escape(key.to_s)}=#{CGI.escape(params[key].to_s)}"
    end * '&'
    uri = URI("#{@default_url}/companies/tasks/#{id}?#{query_params}")

    Net::HTTP.start(uri.host, uri.port) do |http|
        request = Net::HTTP::Delete.new uri
        response = http.request request
    end
  end

  # private
  def sign_request(params)
     params[:timestamp] ||= Time.now.to_i
     params[:access_token] ||= @auth_token
     query_params = params.to_query

     puts "signing #{query_params} with #{@hmac_secret}"
     params.merge(signature: OpenSSL::HMAC.hexdigest("sha1", @hmac_secret, query_params))
  end
 end
