class TournamentsController < ApplicationController
  include TournamentsHelper
  
  before_filter :signed_in_user, :only => [:new, :create]
  before_filter :correct_user, :only => [:edit, :update, :destroy, :activate]
  before_filter :concatenate_datetime, :only => [:create, :update]
  # GET /tournaments
  # GET /tournaments.json
  def index
    @tournaments = Tournament.all
    @footer_bar = true
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tournaments }
    end
  end

  # GET /tournaments/1
  # GET /tournaments/1.json
  def show
    @tournament = Tournament.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tournament }
    end
  end

  # GET /tournaments/new
  def new
    @tournament = Tournament.new
  end

  # GET /tournaments/1/edit
  def edit
    if request.xhr?
      render :layout => false
    else
      redirect_to manage_tournament_path(@tournament)
    end
  end

  # POST /tournaments
  def create
    @tournament = Tournament.new(params[:tournament])
    @tournament.user = current_user
    if @tournament.save
      redirect_to tournaments_user_path(:anchor => "tid=#{@tournament.id}"), :notice => 'Tournament was successfully created.'
    else
      render :action => "new"
    end
  end

  # PUT /tournaments/1
  def update
    if @tournament.active?
      return redirect_to(tournaments_user_path(:anchor => "tid=#{@tournament.id}"), :notice => "You are unable to edit active tournament.")
    end
    if @tournament.update_attributes(params[:tournament])
      redirect_to tournaments_user_path(:anchor => "tid=#{@tournament.id}"), :notice => 'Tournament was successfully updated.'
    else
      redirect_to tournaments_user_path(:anchor => "tid=#{@tournament.id}"), :notice => 'Data is not correct.'
    end
  end

  # DELETE /tournaments/1
  def destroy
    @tournament.destroy
    redirect_to tournaments_user_url
  end
  
  def activate
    @tournament.toggle! :active
    unless @tournament.active?
      @tournament.update_attribute :json_bracket, nil
    end
    redirect_to tournaments_user_url(:anchor => "tid=#{@tournament.id}")
  end
  
  def bracket
    @tournament = Tournament.find(params[:tournament_id])
    
    admin = true if @tournament.user == current_user
    
    if @tournament.active?
      @manage = true if admin
    else
      flash_major_notice "Tournament is not active yet!#{' You have to activate it in your tournaments panel if you want to manage it.' if admin}"
    end
    
    respond_to do |format|
      format.html
      format.json { render json: @tournament.bracket(@manage || false) }
    end
  end
  
  def bracket_update
    @tournament = Tournament.find(params[:tournament_id])
    
    # Update only if user is owner and tournament is activated
    unless @tournament.user == current_user && @tournament.active?
      return render :json => { :updated => false, :error => "You can't update this tournament"}
    end
      
    if @tournament.active
      if @tournament.update_attribute :json_bracket, params[:json_bracket]
        response = { :updated => true }
      else
        response = { :updated => false }
      end
    else
      response = { :updated => false, :error => 'Tournament not active' }
    end
    
    render :json => response.to_json
  end
  
  private
    def correct_user
      @tournament = Tournament.find(params[:id])
      redirect_to root_path unless @tournament.user == current_user
    end
    
    def concatenate_datetime
      if params[:tournament].present?
        params[:tournament][:start_date] = "#{params[:start_date_date]} #{params[:start_date_time]}"
      end
    end
    
end
