class ExceptionSilencer
  def self.is_rate_limit?(exception)
    exception.is_a?(Faraday::Error::ClientError) && exception.response[:status] == 429
  end
end
