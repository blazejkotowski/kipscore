class PlayerAssociationsController < ApplicationController
  
  def activate
    player_association = PlayerAssociation.find_by_email_code(params[:email_code])
    if player_association.present? && player_association.try_to_activate(params[:email_code])
      flash_major_notice I18n.t("custom_translations.confirmed participation", :default => "You have been successfully added to tournament. Now it's time for tournament organizer confirmation. You will be informed by email when it will happen.")
      return redirect_to player_association.tournament
    end
    
    redirect_to root_path
  end
  
  def confirm
    player_association = PlayerAssociation.find_by_player_id_and_tournament_id(params[:player_id], params[:tournament_id])
    if player_association.present?  
      player_association.confirm
      UserMailer.organizer_confirmation(player_association, I18n.locale).deliver
      return render(:json => { :confirmed => true, :player_association => player_association, :player => player_association.player })
    end
    
    render(:json => { :player_association => player_association, :confirmed => false, :player => player_association.player.to_json })
  end  
  
end
