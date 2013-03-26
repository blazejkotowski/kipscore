class RoundRobinTournament < Tournament
  
  def rounds(admin=false)
    list = players.confirmed.best
    player_numbers = generate_rounds
    rounds_list = []
    rounds_hash = player_numbers.map do |matches|
      matches.map do |first, second|
        p1 = (list.at(first) if first.present?)
        p2 = (list.at(second) if second.present?)
        [p1,p2].map do |player|
          if player.present?
            { :name => player.name, :rank => player.rank, :empty => false, :bye => false}
          else
            { :name => "bye", :rank => -1, :empty => false, :bye => true}
          end
        end
      end
    end
    { :admin => admin, :rounds => rounds_hash, :new => true }
  end
  
  private
    def generate_rounds
      size = players.confirmed.size
      numbers = (1...size).to_a
      numbers << nil if size.odd?
      rounds = []
      1.upto(size) do
        rounds << pair_players([0].concat(numbers))
        numbers.rotate!(-1)
      end
      rounds
    end
    
    def pair_players(array)
      first = array.first(array.size/2)
      last = array.last(array.size/2).reverse
      first.zip(last)
    end
end
