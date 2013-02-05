# == Schema Information
#
# Table name: players
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  rank       :integer          default(-1)
#  fetched    :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Player do
  pending "add some examples to (or delete) #{__FILE__}"
end
