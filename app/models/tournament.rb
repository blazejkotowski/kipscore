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
  attr_accessible :active, :name, :start_date, :description, :json_bracket
  belongs_to :user
  has_and_belongs_to_many :players
  
  validates_presence_of :name
  validates_presence_of :start_date
  validates_presence_of :description
  
  default_scope includes(:players, :user)
  
  
  def bracket
    """
    If json_bracket is not defined
      Generates list of players, including byes sorted by
      their starting positions
    Else
      Returns json_bracket value

    Return value
      List of player objects sorted by starting positions
      in json format. Bye are signed by nil
    """
    
    unless json_bracket.nil?
      return json_bracket
    end
    
    puts 'dupa'
    
    list = players.best.reverse # list of players sorted by rank
    power = Math.log2(list.size).ceil # nearest power of 2
    bracket_size = 2**power
    byes_number = bracket_size - list.size # number of "free"
    
    groups = [[0, bracket_size-1]]
    for i in 1...power
      groups.append []
    end
    
    generate_groups(0, bracket_size-1, 1, groups)
    start_list = [-1]*bracket_size
    start_hash_list = []
    
    for group in groups do
      group.shuffle!
      # For each position in shuffled group
      for number in group do
      
        # If there is no player or bye on position, place player
        if start_list[number] == -1
          player = list.pop
          start_list[number] = player
          start_hash_list.append( { :start_position => number, :player => player} )
          
          # If there is free bye, give it to current player
          if byes_number > 0
            if number % 2 == 0
              start_list[number + 1] = nil
              start_hash_list.append( { :start_position => number + 1, :player => nil} )
            else
              start_list[number - 1] = nil
              start_hash_list.append( { :start_position => number - 1, :player => nil} )
            end
            byes_number -= 1
          end
          
        end
        
      end
      
    end
    
    update_attribute(:json_bracket, start_hash_list.to_json)
    self.save!
    json_bracket
    
  end
  
  
  private
    def generate_groups(s, e, group_number, groups)
      """
      Generating groups of players numbers by binary search
      
      Params
        :s - start 
        :e - end
        :group_number - number of current group
        :groups - list of groups
      
      Return value
        Groups list is filled by lists of players numbers like
        [[7, 8], [3, 4, 11, 12], [1, 2, 5, 6, 9, 10, 13, 14]]
        for 16 players
      """
      if e - s > 2
        m = ((s+e)/2).floor
        groups[group_number].append(m)
        groups[group_number].append(m+1)
        generate_groups(s, m, group_number+1, groups)
        generate_groups(m+1, e, group_number+1, groups)
      end
    end  
  
end
