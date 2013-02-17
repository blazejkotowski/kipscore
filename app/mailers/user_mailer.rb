class UserMailer < ActionMailer::Base
  default from: Settings.default_contact_email

  def contact_form(subject, message, user=nil)
    from_email = user
    if user.present?
      if user.class == User
        from_email = "#{user.name} <#{user.email}>"
      end
    end

    @message = message
    @user = user

    mail :from => from_email, :to => Settings.default_contact_email , :subject => subject
  end
  
  def confirm_participation(player_association)
    @player_association = player_association
    to_email = "#{player_association.player.name} <#{player_association.email}>"
    mail :from => Settings.default_noreply_email, :to => to_email, :subject => "#{player_association.tournament.name}  - participation confirmation"
  end
  
end
