class UserMailer < ActionMailer::Base
  layout 'users/mailer'

  default :from => "Team at WeThePeople Commons <#{Settings.support_email}>"
  # enable BCC for production emails
  default :bcc => Settings.bcc_email.split(", ") if Rails.env.production?

  def send_request_confirmation(request_id)
    @request = Request.find_by_id(request_id)
    if @request.present?
      subject = "#{@request.user.first_name.titleize}, your request has been submitted to WeThePeople Commons!"
      mail(:to => @request.user.email, :subject => subject)
    end
  end

  def send_volunteer_confirmation(volunteer_id)
    @volunteer = VolunteerProfile.find_by_id(volunteer_id)
    if @volunteer.present?
      subject = "#{@volunteer.user.first_name.titleize}, your WeThePeople Commons volunteer profile has been created!"
      mail(:to => @volunteer.user.email, :subject => subject)
    end
  end

  private
  # Send mail via basic notification template.
  def _notify(to, subject, message = nil, file_name = nil)
    @sj = subject
    @message = message unless message.nil?
    mail(to: to, subject: @sj, template_path: "admin_mailer", template_name: "notify")
  end

end
