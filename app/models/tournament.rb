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
  
  
  def generate_groups
    
  end
  
  
  def bracket
    list = players.best # list of players sorted by rank
    power = Math.log2(list.size).ceil # nearest power of 2
    bracket_size = 2**power
    byes_number = bracket_size - list.size # number of "free"
    
    groups = []
    for i in 1...power
      groups.append []
    end
    
    generate_groups(0, bracket_size-1, 0, groups)
    
    groups
    
  end
  
  
  private
    def generate_groups(s, e, group_number, groups)
      """
      Generating groups of players numbers by binary search
        :s - start 
        :e - end
        :group_number - number of current group
        :groups - list of groups
      Result
        groups list is filled by lists of players numbers like
        [[7, 8], [3, 4, 11, 12], [1, 2, 5, 6, 9, 10, 13, 14]]
        for 16 players
      """
      if e - s > 2
        puts e, s
        m = ((s+e)/2).floor
        groups[group_number].append(m)
        groups[group_number].append(m+1)
        generate_groups(s, m, group_number+1, groups)
        generate_groups(m+1, e, group_number+1, groups)
      end
    end  
  
end
