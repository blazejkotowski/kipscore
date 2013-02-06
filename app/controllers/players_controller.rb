class PlayersController < ApplicationController

  before_filter :get_tournament, :correct_user, :not_active, :except => [:autocomplete]
  
  def create
    @result = { :created => false, :player => nil, :new => false }
  
    params[:player][:rank] ||= -1
    player = Player.fetched.find_or_initialize_by_name_and_rank params[:player]
    
    if player.new_record?
      player.update_attribute(:fetched, false)
      @result[:new] = true
    end
    
    @tournament.players << player
    @result[:created] = true
    @result[:player] = player
    @result[:delete_url] = tournament_player_path(@tournament, player)
    
    
    respond_to do |format|
      format.json { render :json => @result }
    end
  end
  
  
  def destroy
    player = @tournament.players.find_by_id(params[:id])
    
    @result = { :removed => false, :player => player, :destroyed => false }
    
    unless player.nil?
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
  
  private
    
    def get_tournament
      @tournament = Tournament.find(params[:tournament_id])
    end
    
    def correct_user
      unless @tournament.user == current_user
        @result = { :error => 'No access' }
        render_result
      end
    end
    
    def render_result
      render :json => @result
    end
    
    def not_active
      if @tournament.active
        @result = { :error => 'Tournament active' }
        render_result
      end
    end
    
end
