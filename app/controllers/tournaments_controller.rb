class TournamentsController < ApplicationController
  include TournamentsHelper
  
  before_filter :signed_in_user, :only => [:new, :create]
  before_filter :correct_user, :only => [:edit, :update, :destroy, :start, :finish]
  before_filter :get_tournament, :only => [:results, :results_update]
  before_filter :concatenate_datetime, :only => [:create, :update]
  before_filter :perform_search, :only => [:index, :search]
  
  # GET /tournaments
  # GET /tournaments.json
  def index
    @footer_bar = true
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tournaments }
    end
  end
  
  def search
    @footer_bar = true
    render 'index'
  end

  # GET /tournaments/1
  # GET /tournaments/1.json
  def show
    @tournament = Tournament.with_form.find(params[:id])

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
    @rankings = Ranking.all.map { |ranking| [ranking.name, ranking.id] }
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
      redirect_to tournaments_user_path(:anchor => "tid=#{@tournament.id}"), :notice => I18n.t("custom_translations.tournament was successfully created", :default => 'tournament was successfully created').capitalize
    else
      render :action => "new"
    end
  end

  # PUT /tournaments/1
  def update
    unless @tournament.created?
      return redirect_to(tournaments_user_path(:anchor => "tid=#{@tournament.id}"), :notice => I18n.t("custom_translations.you are unable to edit active tournament", :default => "you are unable to edit active tournament.").capitalize)
    end
    if @tournament.update_attributes(params[:tournament])
      redirect_to tournaments_user_path(:anchor => "tid=#{@tournament.id}"), :notice => I18n.t("custom_translations.tournament was successfully updated", :default => 'tournament was successfully updated').capitalize
    else
      redirect_to tournaments_user_path(:anchor => "tid=#{@tournament.id}"), :notice => I18n.t("custom_translations.data is not correct", :default => 'data is not correct').capitalize
    end
  end

  # DELETE /tournaments/1
  def destroy
    if @tournament.finished?
      redirect_to tournaments_user_url(:anchor => "tid=#{@tournament.id}"), :notice => I18n.t("custom_translations.You can't delete finsihed tournament")
    else
      @tournament.destroy
    end
    redirect_to tournaments_user_url
  end
  
  def start
    notice = nil
    if @tournament.created?
      @tournament.start
    elsif @tournament.started?
      @tournament.stop    
      @tournament.update_attributes :json_bracket => nil, :json_results => nil
    else
      notice = I18n.t("custom_translations.This tournament is already finished")
    end
    redirect_to tournaments_user_url(:anchor => "tid=#{@tournament.id}"), :notice => notice
  end
  
  def finish
    notice = I18n.t("custom_translations.Successfully finished tournament")
    unless @tournament.finish
      notice = I18n.t("custom_translations.This tournament is not even started")
    end
    redirect_to tournaments_user_url(:anchor => "tid=#{@tournament.id}"), :notice => notice
  end
  
  def bracket
    @tournament = Tournament.find(params[:tournament_id])
    
    @manage = true if @tournament.user == current_user && @tournament.started?
    
    respond_to do |format|
      format.html { redirect_to @tournament, :notice => I18n.t("custom_translations.Tournament is not started yet") unless @tournament.started? || @tournament.finished?  }
      format.json do 
        if params[:random].present?
          render json: @tournament.random_bracket
        else
          render json: @tournament.bracket(@manage || false)
        end
      end
    end
  end
  
  def bracket_update
    @tournament = Tournament.find(params[:tournament_id])
    
    # Update only if user is owner
    if @tournament.user != current_user || @tournament.finished?
      return render :json => { :updated => false, :error => "You can't update this tournament"}
    end
      
    if @tournament.update_attribute :json_bracket, params[:json_bracket]
      response = { :updated => true }
    else
      response = { :updated => false }
    end
    
    render :json => response.to_json
  end
  
  def results
    render :json => @tournament.results.to_json
  end
  
  def results_update
    @tournament = Tournament.find(params[:tournament_id])
    # Update only if user is owner and tournament is activated
    unless @tournament.user == current_user && @tournament.started?
      return render :json => { :updated => false, :error => "You can't update this tournament"}
    end
    
    @tournament.update_attribute :json_results, params[:json_results]
    render :json => { :updated => true }
  end
  
  private
    def correct_user
      @tournament = Tournament.with_form.find(params[:id])
      redirect_to root_path unless @tournament.user == current_user
    end
    
    def concatenate_datetime
      if params[:tournament].present?
        params[:tournament][:start_date] = "#{params[:start_date_date]} #{params[:start_date_time]}"
      end
    end
    
    def get_tournament
      @tournament = Tournament.find(params[:tournament_id])
    end
    
    def perform_search
      case params.try('[]', :state)
      when 'started'
        @search = Tournament.started.search(params[:q])
      when 'finished'
        @search = Tournament.finished.search(params[:q])
      else
        @search = Tournament.created.search(params[:q])
      end
          
      @tournaments = @search.result
    end
    
end
