class PlayersController < ApplicationController

  before_filter :get_tournament, :only => [:create, :destroy, :activate]
  before_filter :correct_user, :only => [:destroy]
  
  def create
    @result = { :created => false, :player => nil, :new => false }
      
    params[:player][:rank] ||= -1
    player = Player.fetched.find_or_initialize_by_name_and_rank params[:player]
      
    if player.new_record?
      player.update_attribute(:fetched, false)
      @result[:new] = true
    end
    
    if request.xhr? && @tournament.user == current_user
      player_association = PlayerAssociation.create(:player => player, :tournament => @tournament, :state => :confirmed)
      @result[:created] = true
      @result[:player] = player
      @result[:player_association] = player_association
      @result[:delete_url] = tournament_player_path(@tournament, player)
      render :json => @result  
    
    else
      player_association = PlayerAssociation.new(params[:player_association].merge({:player => player, :tournament => @tournament}))
      player_association.email = "" if player_association.email.nil?
      if player_association.save
        UserMailer.confirm_participation(player_association, I18n.locale).deliver
        message = I18n.t("custom_translations.joined tournament", :default => "You have joined tournament, but it's not all! Now check your mail to confirm your participation. Without email confirmation your participation desire will be ignored!")
        
        if request.xhr?
          render :json => { :created => true, :message => message }.to_json
        else
          flash_major_notice message
          redirect_to tournament_path(@tournament)
        end
      else
        if request.xhr?
          render :json => { :created => false, :message => I18n.t('custom_translations.email not valid') }
        else
          flash.now[:notice] = I18n.t('custom_translations.email not valid').capitalize
          render "new"
        end
      end
    end
    
  end
  
  
  def destroy
    player = @tournament.players.find_by_id(params[:id])
    
    @result = { :removed => false, :player => player, :destroyed => false }
    
    unless player.nil?
      pa = @tournament.player_associations.find_by_player_id(player.id)
      pa.delete
      
      unless player.fetched
        player.delete
        @result[:destroyed] = true
      end
            
      @result[:removed] = true
      @result[:player_association] = pa
    end
      
    respond_to do |format|
      format.json { render :json => @result }
    end
  end
  
  def new
    @tournament = Tournament.with_form.find(params[:tournament_id])
    redirect_to @tournament unless @tournament.joinable?
  end
  
  def activate
    
  end
  
  private
    
    def get_tournament
      @tournament = Tournament.find(params[:tournament_id])
    end
    
    def correct_user
      unless @tournament.user == current_user
        @result = { :error => 'No access' }
        if request.xhr?
          render_result
        else
          redirect_to @tournament
        end
      end
    end
    
    def render_result
      render :json => @result
    end
    
    def not_active
      unless @tournament.created?
        @result = { :error => 'Tournament active' }
        if request.xhr?
          render_result
        else
          redirect_to @tournament
        end
      end
    end
    
end
