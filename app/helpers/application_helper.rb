module ApplicationHelper
  include SanitizeUrl
  # Remove any internationalization and spaces in a phone number
  def sanitize_phone_number(number)
    number.gsub(/\+1/, '').gsub(/^1\-/, '').gsub(/^1 /, '').gsub(/\D/, '') if number.present?
  end

  def scrub_url(url)
    sanitized_url = sanitize_url(url)
    if sanitized_url.is_valid_url?
      parsed_url  = URI.parse(sanitized_url)
    else
      raise "URL invalid"
    end

    return parsed_url.host.scan(/^(www.)/).present? ? parsed_url.host : ("www." + parsed_url.host)
  end
end
