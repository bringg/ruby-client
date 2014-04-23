 require 'net/http'
 require 'OpenSSL'
 require 'json'
 require 'date'
 require 'cgi' unless defined?(CGI) && defined?(CGI::escape)

 class BringgClient
   def initialize(options = {})
    @options = options.dup
    @auth_token = options[:auth_token]
    @hmac_secret = options[:hmac_secret]
    @default_url = options[:url]
    @default_url ||= "http://api.overvyoo.com"
  end

  def create_customer(customer_details)
    uri = URI("#{@default_url}/partner_api/customers")
    params = customer_details
    Net::HTTP.post_form(uri, sign_request(params))
  end

  def create_task(task_deails)
    uri = URI("#{@default_url}/partner_api/tasks")
    params = task_deails
    Net::HTTP.post_form(uri, sign_request(params))
  end

  def add_waypoint(task_id, way_point_details)
    uri = URI("#{@default_url}/partner_api/tasks/#{task_id}/way_points/")
    params = way_point_details
    Net::HTTP.post_form(uri, sign_request(params))
  end

  private
  def sign_request(params)
     params[:timestamp] ||= Time.now.to_i
     params[:access_token] ||= @auth_token
     query_params = params.collect do |key,val|
       "#{CGI.escape(key.to_s)}=#{CGI.escape(val.to_s)}"
     end.sort * '&'
     puts "signing #{query_params}"
     params.merge(signature: OpenSSL::HMAC.hexdigest("sha1", @hmac_secret, query_params))
  end
 end
