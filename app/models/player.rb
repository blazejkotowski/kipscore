# == Schema Information
#
# Table name: players
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  rank         :integer          default(-1)
#  user_created :boolean          default(FALSE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Player < ActiveRecord::Base
  attr_accessible :name, :rank, :user_created
  has_and_belongs_to_many :tournaments
  
  validates_presence_of :name
  
  default_scope order('created_at DESC')
  
end
