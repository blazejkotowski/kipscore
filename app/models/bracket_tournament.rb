class BracketTournament < Tournament
  attr_accessible :json_bracket
  
  state_machine do
    state :started do
      validates_presence_of :json_bracket
    end
  end
  
  def bracket(admin=false)
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
    
    if json_bracket.present?
      return (JSON.parse(json_bracket).merge({ :admin=>admin })).to_json
    end
    
    # Get random bracket
    start_hash_list = generate_bracket
    
    json_list = json_bracket_from_players(start_hash_list)
    update_attribute :json_bracket, json_list if started?
    json_list.merge({:admin => admin, :new => true})
  end
  
  def random_bracket
    start_hash_list = generate_bracket
    json_bracket_from_players(start_hash_list)
  end
  
  def generate_bracket
    # list of players sorted by rank
    list = players.confirmed.best
    iter = list.size
    while iter > 0 && list.first.rank.nil? do
      list.rotate! 1
      iter-=1
    end
    list.reverse!
    
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
    
    first_in_group = 1
    groups.each_with_index do |group, index|
      group.shuffle! unless index == 0
      # For each position in shuffled group
      for number in group do
      
        # If there is no player or bye on position, place player
        if start_list[number] == -1
          player = list.pop
          start_list[number] = player
          start_hash_list.append( { :start_position => number, :name => player.name, :rank => player.rank, :empty => false, :label => "#{first_in_group}-#{first_in_group+group.size-1}", :label_id => index } )
          
          # If there is free bye, give it to current player
          if byes_number > 0
            if number % 2 == 0
              start_list[number + 1] = nil
              start_hash_list.append( { :start_position => number + 1, :empty => false, :name => 'bye', :bye => true } )
            else
              start_list[number - 1] = nil
              start_hash_list.append( { :start_position => number - 1, :empty => false, :name => 'bye', :bye => true } )
            end
            byes_number -= 1
          end
          
        end
      end
      first_in_group += group.size
      
    end
    
    start_hash_list.sort! { |a,b| a[:start_position] <=> b[:start_position] }
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
    
    def json_bracket_from_players(start_list)
      { :players => start_list }
    end
  
end
