class StaticPagesController < ApplicationController
  
  before_filter :footer_bar

  layout lambda { |controller| request.xhr? ? false : "application" }
  
  def home
    @user = User.new
    @footer_bar = true
  end

  def about
  end

  def contact
  end
  
  def instruction
  end
  
  def innovation
  end
  
  private
    def footer_bar
      @footer_bar = true
    end
end
