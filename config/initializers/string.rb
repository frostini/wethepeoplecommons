class String
  def is_valid_url?
    uri = URI.parse self
    (uri.kind_of? URI::HTTP || URI::HTTPS) && self.scan(/^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/).present?
  rescue URI::InvalidURIError
    false
  end
end
