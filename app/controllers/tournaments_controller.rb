class TournamentsController < ApplicationController
  before_filter :signed_in_user, :only => [:new, :create, :edit, :update, :destroy, :activate]
  before_filter :correct_user, :only => [:edit, :update, :destroy, :activate]
  before_filter :concatenate_datetime, :only => [:create, :update]
  # GET /tournaments
  # GET /tournaments.json
  def index
    @tournaments = Tournament.all

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
    @tournament.active = true
    @tournament.save
    redirect_to tournaments_user_url(:anchor => "tid=#{@tournament.id}")
  end
  
  private
    def correct_user
      @tournament = Tournament.find(params[:id])
      redirect_to root_path unless @tournament.user == current_user
    end
    
    def concatenate_datetime
      params[:tournament][:start_date] = "#{params[:start_date_date]} #{params[:start_date_time]}"
    end
end
