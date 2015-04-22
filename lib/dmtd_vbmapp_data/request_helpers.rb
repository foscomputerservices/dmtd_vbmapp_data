require 'net/http'
require 'uri'

module DmtdVbmappData

  class RequestHelpers

    # GET an authorized message from the vbmappdata server
    #
    # Params:
    # +end_point+:: The end point to post
    # +params+:: The parameters to send to the end point (may be nil)
    # +client_id+:: The client id under which to record the post (may be nil)
    # +client_code+:: The client code under which to record the post (maybe nil)
    def self.get_authorized(opts = {})
      end_point = opts.fetch(:end_point)
      params = opts.fetch(:params, nil)
      client_id = opts.fetch(:client_id, nil)
      client_code = opts.fetch(:client_code, nil)

      get url(end_point), params, client_id, client_code
    end

    # POST an authorized message to the vbmappdata server
    #
    # Params:
    # +end_point+:: The end point to post
    # +params+:: The parameters to send to the end point (may be nil)
    # +client_id+:: The client id under which to record the post (may be nil)
    # +client_code+:: The client code under which to record the post (maybe nil)
    def self.post_authorized(opts = {})
      end_point = opts.fetch(:end_point)
      params = opts.fetch(:params, nil)
      client_id = opts.fetch(:client_id, nil)
      client_code = opts.fetch(:client_code, nil)

      post url(end_point), params, client_id, client_code
    end

    # def put_authorized(path, parameters = nil, user = nil, client = nil, headers_or_env = nil)
    #   put path, parameters, add_auth(headers_or_env, user, client)
    # end
    #
    # def delete_authorized(path, parameters = nil, user = nil, client = nil, headers_or_env = nil)
    #   delete path, parameters, add_auth(headers_or_env, user, client)
    # end

    private

    def self.get(uri, params, client_id, client_code)
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.request_uri)
      add_auth(request, client_id, client_code)
      request.set_form_data params

      http.request(request)
    end

    def self.post(uri, params, client_id, client_code)
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.request_uri)
      add_auth(request, client_id, client_code)
      request.body = JSON(params)

      http.request(request)
    end

    def self.url(end_point)
      URI.parse("#{DmtdVbmappData.config[:server_url]}/#{end_point}")
    end

    def self.add_auth(request, client_id = nil, client_code = nil)
      session_token = DmtdVbmappData.config[:auth_token]

      request['Authorization'] = "Token token=\"#{session_token}\""
      request['Accept'] = 'application/json'
      request['Content-Type'] = 'application/json'
      request['X-ClientId'] = client_id unless client_id.nil?
      request['X-ClientCode'] = client_code unless client_code.nil?
    end
  end
end