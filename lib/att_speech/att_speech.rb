class ATTSpeech
  include Celluloid
  Celluloid.logger = nil

  attr_reader :api_key, :secret_key, :access_token, :refresh_token, :base_url, :ssl_verify, :scope

  ##
  # Creates an ATTSpeech object
  #
  # @overload initialize(args)
  #   @param [Hash] args the options to intantiate with
  #   @option args [String] :api_key the AT&T Speech API Key
  #   @option args [String] :secret_key the AT&T Speech API Secret Key
  #   @option args [String] :scope the Authorization Scope for the AT&T Speech API
  #   @option args [String] :base_url the url for the AT&T Speech API, default is 'https://api.att.com'
  #   @option args [Boolean] :ssl_verify determines if the peer Cert is verified for SSL, default is true
  # @overload initialize(api_key, secret_key, base_url='https://api.att.com')
  #   @param [String] api_key the AT&T Speech API Key
  #   @param [String] secret_key the AT&T Speech API Secret Key
  #   @param [String] scope the Authorization Scope for the AT&T Speech API
  #   @param [String] base_url the url for the AT&T Speech API, default is 'https://api.att.com'
  #   @param [Boolean] ssl_verify determines if the peer Cert is verified for SSL, default is true
  #
  # @return [Object] an instance of ATTSpeech
  def initialize(*args)
    raise ArgumentError, "Requires at least the api_key, secret_key, and scope when instatiating" if args.size == 0

    base_url   = 'https://api.att.com'

    if args.size == 1 && args[0].instance_of?(Hash)
      @api_key    = args[0][:api_key]
      @secret_key = args[0][:secret_key]
      @scope      = args[0][:scope]
      @base_url   = args[0][:base_url]   || base_url
      set_ssl_verify args[0][:ssl_verify]
    else
      @api_key    = args[0]
      @secret_key = args[1]
      @scope      = args[2]
      @base_url   = args[3] || base_url
      set_ssl_verify args[4]
    end

    raise ArgumentError, "scope must be either 'SPEECH' or 'TTS'" unless (@scope == 'SPEECH') || (@scope == 'TTS')

    @grant_type    = 'client_credentials'
    @access_token  = ''
    @refresh_token = ''

    if @scope == 'SPEECH'
      create_connection 'application/json'
    else
      create_connection 'audio/x-wav'
    end

    get_tokens

    Actor.current
  end

  ##
  # Allows you to send a file and return the speech to text result
  # @param [String] file_contents to be processed
  # @param [String] type of file to be processed, may be audio/wav, application/octet-stream or audio/amr
  # @param [String] speech_context to use to evaluate the audio BusinessSearch, Gaming, Generic, QuestionAndAnswer, SMS, SocialMedia, TV, VoiceMail, WebSearch
  # @param [Block] block to be called when the transcription completes
  #
  # @return [Hash] the resulting response from the AT&T Speech API
  def speech_to_text(file_contents, type='audio/wav', speech_context='Generic', &block)
    resource = "/speech/v3/speechToText"

    if type == "application/octet-stream"
      type = "audio/amr"
    end

    begin
      response = @connection.post( resource,
                                   file_contents,
                                   :Authorization             => "Bearer #{@access_token}",
                                   :Content_Transfer_Encoding => 'chunked',
                                   :X_SpeechContext           => speech_context,
                                   :Content_Type              => type,
                                   :Accept                    => 'application/json' )

      result = process_response(response)
      block.call result if block_given?
      result
    rescue => e
      raise RuntimeError, e.to_s
    end
  end


  ##
  # Allows you to send a string or plain text file and return the text to speech result
  # @param [String] text_data string or file_contents to be processed
  # @param [String] options hash with options which will be send to AT&T Speech API
  #
  # @return [String] the bytes of the resulting response from the AT&T Speech API
  def text_to_speech(text_data, options = {})
    resource = '/speech/v3/textToSpeech'
    params = {
      :Authorization => "Bearer #{@access_token}",
      :Content_Type  => 'text/plain',
      :Accept        => 'audio/x-wav'
    }.merge(options)

    begin
      response = @connection.post( resource, text_data, params )
      response.body
    rescue => e
      raise RuntimeError, e.to_s
    end
  end


  private

  ##
  # Creates the Faraday connection object
  def create_connection(accept_type='application/json')
    @connection = Faraday.new(:url => @base_url, :ssl => { :verify => @ssl_verify }) do |faraday|
      faraday.headers['Accept'] = accept_type
      faraday.adapter           Faraday.default_adapter
    end
  end

  ##
  # Obtains the session tokens
  def get_tokens
    resource = "/oauth/access_token"

    begin
      response = @connection.post resource do |request|
        request.params['client_id']     = @api_key
        request.params['client_secret'] = @secret_key
        request.params['grant_type']    = @grant_type
        request.params['scope']         = @scope
      end

      result = process_response(response)

      if result[:access_token].nil? || result[:refresh_token].nil?
        raise RuntimeError, "Unable to complete oauth: #{response[:error]}"
      else
        @access_token  = result[:access_token]
        @refresh_token = result[:refresh_token]
      end
    rescue => e
      raise RuntimeError, e.to_s
    end
  end

  ##
  # Process the JSON returned into a Hashie::Mash and making it more Ruby friendly
  #
  # @param [String] reponse json
  #
  # @return [Object] a Hashie::Mash object
  def process_response(response)
    Hashie::Mash.new(underscore_hash(JSON.parse(response.body)))
  end

  ##
  # Sets the ssl_verify option
  #
  # @param [Boolean] ssl_verify the variable to set
  def set_ssl_verify(ssl_verify)
    if ssl_verify == false
      @ssl_verify =  false
    else
      @ssl_verify = true
    end
  end

  ##
  # Decamelizes the keys in a hash to be more Ruby friendly
  #
  # @param [Hash] hash to be decamelized
  #
  # @return [Hash] the hash with the keys decamalized
  def underscore_hash(hash)
    hash.inject({}) do |underscored, (key, value)|
      value = underscore_hash(value) if value.is_a?(Hash)
      if value.is_a?(Array)
        value = underscore_hash(value[0]) if value[0].is_a?(Hash)
      end
      underscored[key.underscore] = value
      underscored
    end
  end
end
