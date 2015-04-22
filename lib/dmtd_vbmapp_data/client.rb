require 'dmtd_vbmapp_data/request_helpers'

module DmtdVbmappData

  GENDER_MALE=1
  GENDER_FEMALE=2

  # Provides for the creating and retrieving of client instances in the VB-MAPP Data Server.
  class Client

    attr_reader :id
    attr_reader :organization_id
    attr_reader :code
    attr_reader :date_of_birth
    attr_reader :first_name
    attr_reader :last_name
    attr_reader :settings
    attr_reader :created_at
    attr_reader :updated_at
    attr_reader :server_response_code

    # Creates a new client on the VB-MAPP Data Server
    #
    # Note that +code+ may be specified as a key of the corresponding record in your database.
    # This allows the client to be referred to later on via this key as opposed to the id
    # generated by our system.  Using this option means that your application data is not required
    # to store a new id for the client, but can use your existing id (primary key).
    #
    # This operation blocks until it receives a response from the VB-MAPP Data Server.
    #
    # If +id+ is specified, then the instance will *not* be sent to the server, it is assumed to already be there.
    #
    # Params:
    # +date_of_birth+:: the date of birth of the client as a ruby Date object
    # +gender+:: the gender of the client, either +GENDER_MALE+ or +GENDER_FEMALE+
    # +id+:: the vbmapp_data server's identifier for this client (may be nil)
    # +organization_id+:: the organization identifier (may be nil, if so 1 will be used by default)
    # +code+:: a code that can be used to refer to the client; possibly a key in the customer's database (may be nil)
    # +first_name+:: the first name of the client (may be nil)
    # +last_name+:: the last name of the client (may be nil)
    # +settings+:: a string value that can be associated with the client (may be nil)
    def initialize(opts)
      @date_of_birth = opts.fetch(:date_of_birth)
      @gender = opts.fetch(:gender)
      @id = opts.fetch(:id, nil)
      @organization_id = opts.fetch(:organization_id, 1)
      @code = opts.fetch(:code, nil)
      @first_name = opts.fetch(:first_name, nil)
      @last_name = opts.fetch(:last_name, nil)
      @settings = opts.fetch(:settings, nil)
      @server_response_code = opts.fetch(:server_response_code, 200)
      @created_at = opts.fetch(:created_at, Date.now.getutc)
      @updated_at = opts.fetch(:updated_at, Date.now.getutc)

      create_server_client if @id.nil?
    end

    # Retrieves all existing clients from the VB-MAPP Data Server
    #
    # This operation blocks until it receives a response from the VB-MAPP Data Server.
    #
    # Result:
    # Array of DmtdVbmappData::Client instances or server http response code (integer) if an error was received
    def self.retrieve_clients(opts = {})
      retrieve_server_clients(opts)
    end

    private

    def self.end_point
      '1/clients'
    end

    def create_server_client
      params = { date_of_birth: @date_of_birth, gender: @gender, organization_id: @organization_id }
      params[:code] = code unless code.nil?
      params[:first_name] = first_name unless first_name.nil?
      params[:last_name] = last_name unless last_name.nil?
      params[:settings] = settings unless settings.nil?

      proc_response = Client.process_response(RequestHelpers::post_authorized(end_point: Client::end_point, params: {object: params}))
      json = proc_response[:json]
      @server_response_code = proc_response[:code]

      @id = json[:id] unless json.nil?
    end

    def self.retrieve_server_clients(opts)
      result = nil
      id = opts.fetch(:id, nil)
      code = opts.fetch(:code, nil)
      organization_id = opts.fetch(:organization_id, 1)

      params = { organization_id: organization_id }

      response = RequestHelpers::get_authorized(end_point: Client::end_point, params: params, client_id: id, client_code: code)
      proc_response = process_response(response)
      json_array = proc_response[:json]
      server_response_code = proc_response[:code]

      result = json_array.map {|json| json[:server_response_code] = server_response_code; Client.new(json) } unless json_array.nil?
      result = server_response_code if json_array.nil?

      result
    end

    def self.process_response(response)
      json = nil
      server_response_code = response.code.to_i

      if server_response_code == 200
        json_body = Hashie.symbolize_keys!(JSON.parse(response.body))
        json = json_body[:response]
      end

      { json: json, code: server_response_code }
    end
  end

end