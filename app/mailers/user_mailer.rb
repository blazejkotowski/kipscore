class UserMailer < ActionMailer::Base
  default from: "contact@kipscore.com"

  def contact_form(subject, message, user=nil)
    from_email = user
    if user.present?
      if user.class == User
        from_email = "#{user.name} <#{user.email}>"
      end
    end

    @message = message
    @user = user

    mail :from => from_email, :to => "kotowski.blazej@gmail.com", :subject => subject
  end
end
