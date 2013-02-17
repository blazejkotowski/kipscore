class PlayersController < ApplicationController

  before_filter :get_tournament, :not_active, :except => [:autocomplete]
  before_filter :correct_user, :except => [:autocomplete, :create, :new, :activate]
  
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
      @result[:delete_url] = tournament_player_path(@tournament, player)
      render :json => @result
      
    elsif !request.xhr?
      player_association = PlayerAssociation.create(:email => params[:email], :player => player, :tournament => @tournament)
      UserMailer.confirm_participation(player_association).deliver
      flash_major_notice I18n.t("custom_translations.joined tournament", :default => "You have joined tournament, but it's not all! Now check your mail to confirm your participation. Without email confirmation your participation desire will be ignored!")
      redirect_to tournament_path(@tournament)
    end
    
  end
  
  
  def destroy
    player = @tournament.players.find_by_id(params[:id])
    
    @result = { :removed => false, :player => player, :destroyed => false }
    
    unless player.nil?
      @tournament.player_associations.find_by_player_id(player.id).delete
      unless player.fetched
        player.delete
        @result[:destroyed] = true
      else
        @tournament.players.delete(player)
      end
      
      @result[:removed] = true
    end
      
    respond_to do |format|
      format.json { render :json => @result }
    end
  end
  
  def new
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
      if @tournament.active
        @result = { :error => 'Tournament active' }
        if request.xhr?
          render_result
        else
          redirect_to @tournament
        end
      end
    end
    
end
