class StaticPagesController < ApplicationController

  layout lambda { |controller| request.xhr? ? false : "application" }
  
  def home
    @user = User.new
  end

  def about
  end

  def contact
  end
  
  def instruction
  end
  
  def innovation
  end
  
end
