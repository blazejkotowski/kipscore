class PlayersController < ApplicationController

  before_filter :get_tournament
  
  def create
    params[:player][:rank] ||= -1
    player = Player.new params[:player]
    @result = { :created => false, :player => player }
    
    if @tournament.user == current_user && player.save
      @tournament.players << player
      @result[:created] = true
      @result[:delete_url] = tournament_player_path(@tournament, player)
    end
    
    respond_to do |format|
      format.json { render :json => @result }
    end
    
  end
  
  
  def destroy
    player = @tournament.players.where(:id => params[:id]).first
    
    @result = { :removed => false, :player => player }
    
    unless @tournament.user == current_user && player.nil?
      player.delete
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
    
end
