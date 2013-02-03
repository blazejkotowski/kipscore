# == Schema Information
#
# Table name: tournaments
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  name       :string(255)
#  start_date :datetime
#  active     :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Tournament < ActiveRecord::Base
  attr_accessible :active, :name, :start_date, :description
  belongs_to :user
  has_and_belongs_to_many :players
  
  validates_presence_of :name
  validates_presence_of :start_date
  validates_presence_of :description
  
  default_scope includes(:players, :user)
  
end
