require 'dmtd_vbmapp_data/request_helpers'

module DmtdVbmappData

  GENDER_MALE=1
  GENDER_FEMALE=2

  # Provides for the creating and retrieving of client instances in the VB-MAPP Data Server.
  class Client

    # @!attribute [r] client
    #   @return [Client] the associated client

    # @!attribute [r] id
    #   @return [Integer] a unique identifier for this client
    attr_reader :id

    # @!attribute [r] organization_id
    #   @return [Integer] a unique identifier for the organization that owns the client
    attr_reader :organization_id

    # @!attribute [r] code
    #   @return [String] a code that can be used to refer to the client; possibly a key in the customer's database (may be nil)
    attr_reader :code

    # @!attribute [r] date_of_birth
    #   @return [Date] the date of birth of the client
    attr_reader :date_of_birth

    # @!attribute [r] first_name
    #   @return [String] the first name of the client
    attr_reader :first_name

    # @!attribute [r] last_name
    #   @return [String] the last name of the client
    attr_reader :last_name

    # @!attribute [r] settings
    #   @return [String]
    attr_reader :settings

    # @!attribute [r] created_at
    #   @return [DateTime] the UTC time at which the client was created
    attr_reader :created_at

    # @!attribute [r] updated_at
    #   @return [DateTime] the UTC time at which the client was last updated
    attr_reader :updated_at

    # @!attribute [r] server_response_code
    #   @return [Integer] the response code from the server; 200 == OK
    attr_reader :server_response_code

    # @!attribute [r] language
    #   @return [String] the language in which to retrieve the information for the client
    attr_reader :language

    # Creates a new client on the VB-MAPP Data Server
    #
    # @note The {code} may be specified as a key of the corresponding record in your database.
    #   This allows the client to be referred to later on via this key as opposed to the id
    #   generated by our system.  Using this option means that your application data is not required
    #   to store a new id for the client, but can use your existing id (primary key).
    #
    # @note This operation blocks until it receives a response from the VB-MAPP Data Server.
    #
    # @note If {is_valid_for_create?} returns false, then the instance will *not* be sent to the server, it is assumed to already be there.
    #   Otherwise it will be sent to the server.
    #
    # @note Language is *not* stored on the server along with the client information and thus, it must be
    #   specified each time the instance is created if a language other than the default is needed.
    #
    # @option opts [Date] :date_of_birth The date of birth of the client as a ruby Date object (may be nil)
    # @option opts [Integer] :gender The gender of the client, either {GENDER_MALE} or {GENDER_FEMALE} (may be nil if {is_valid_for_create?})
    # @option opts [String] :id The vbmapp_data server's identifier for this client (may be nil)
    # @option opts [String] :organization_id The organization identifier (may be nil, if so {DmtdVbmappData.config}['organization_id'] will be used)
    # @option opts [String] :code A code that can be used to refer to the client; possibly a key in the customer's database (may be nil)
    # @option opts [String] :first_name The first name of the client (may be nil)
    # @option opts [String] :last_name The last name of the client (may be nil)
    # @option opts [String] :settings A string value that can be associated with the client (may be nil)
    # @option opts [String] :language The language to use (i.e. 'en', 'es' or may be nil) @see #DmtdVbmappData.AVAILABLE_LANGUAGES
    def initialize(opts)
      dob = opts.fetch(:date_of_birth, nil)
      @date_of_birth = dob ? (dob.is_a?(String) ? DateTime.parse(dob) : dob.to_date) : nil
      @gender = opts.fetch(:gender, nil) ? opts.fetch(:gender).to_i : nil

      id = opts.fetch(:id, nil)
      @id = id.nil? ? nil : id.to_i
      @organization_id = opts.fetch(:organization_id, DmtdVbmappData.config[:organization_id]).to_i
      @code = opts.fetch(:code, nil)
      @first_name = opts.fetch(:first_name, nil)
      @last_name = opts.fetch(:last_name, nil)
      @settings = opts.fetch(:settings, nil)
      @server_response_code = opts.fetch(:server_response_code, 200)
      @language = opts.fetch(:language, nil)

      date_now = DateTime.now.new_offset(0)

      created_at = opts.fetch(:created_at, date_now)
      @created_at = created_at.is_a?(String) ? DateTime.parse(created_at) : created_at

      updated_at = opts.fetch(:updated_at, date_now)
      @updated_at = updated_at.is_a?(String) ? DateTime.parse(updated_at) : updated_at

      create_server_client if is_valid_for_create?
    end

    # Retrieves all existing clients from the VB-MAPP Data Server
    #
    # @note This operation *blocks* until it receives a response from the VB-MAPP Data Server.
    #
    # @option opts [String] :organization_id The organization identifier (may be nil, if so {DmtdVbmappData.config}['organization_id'] will be used)
    # @option opts [String] :language The language to use (i.e. 'en', 'es' or may be nil) @see #DmtdVbmappData.AVAILABLE_LANGUAGES
    #
    # @return [Array<Client> | Integer] http response code (integer) if an error was received
    def self.retrieve_clients(opts = {})
      retrieve_server_clients(opts)
    end

    # @note This method does *not* block
    #
    # @return [Guide]
    def guide
      Guide.new(client: self, language: language)
    end

    # @note This method does *not* block
    #
    # @return [Vbmapp]
    def vbmapp
      Vbmapp.new(client: self, language: language)
    end

    # @note This method does *not* block
    #
    # @return [AssessmentReport]
    def iep_report(&resolver)
      AssessmentReport.new(client: self, language: language, &resolver).iep
    end

    # @return [true | false] true if the receiver is parametrized correctly for creation on the server
    def is_valid_for_create?
      @id.nil? && !@date_of_birth.nil? && !@gender.nil? && !@organization_id.nil?
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
      language = opts.fetch(:language, nil)
      organization_id = opts.fetch(:organization_id, DmtdVbmappData.config[:organization_id])

      response = RequestHelpers::get_authorized(end_point: Client::end_point, params: {organization_id: organization_id}, language: language)
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