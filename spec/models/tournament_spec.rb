# == Schema Information
#
# Table name: tournaments
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  name         :string(255)
#  start_date   :datetime
#  active       :boolean
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  description  :text
#  json_bracket :text
#

require 'spec_helper'

describe Tournament do
  pending "add some examples to (or delete) #{__FILE__}"
end
