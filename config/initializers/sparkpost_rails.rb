SparkPostRails.configure do |c|
  c.api_key = ENV['SPARKPOST_API_KEY']
  c.sandbox = !Rails.env.production?
  c.track_opens = true
  c.track_clicks = true
  c.transactional = true
  c.inline_css = true
  c.html_content_only = true
end
