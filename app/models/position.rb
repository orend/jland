# == Schema Information
#
# Table name: positions
#
#  id             :integer         not null, primary key
#  user_id        :integer         not null
#  lead_search_id :integer
#  source         :string(255)
#  name           :string(255)     not null
#  details        :text
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  pstatus        :string(255)     default("to_apply"), not null
#  company        :string(255)
#  comments       :text
#  app_link       :text
#  app_due_date   :datetime
#  starred        :boolean         default(FALSE), not null
#  city           :string(255)
#  state          :string(255)
#  country        :string(255)
#  post_date      :datetime
#

class Position < ActiveRecord::Base

  PSTATES = ['to_review', 'to_apply', 'applied', 'to_schedule', 'interviewed', 'rejected', 'offered', 'not_interested' ].freeze

  belongs_to :user
  belongs_to :lead_search
  has_many :related_emails

  validates :pstatus, :presence => true, :inclusion => { :in => PSTATES, :message => "%{value} is not a valid position status" }
  validates :name, :presence => true

  def to_s
    "name: #{name}, status: #{pstatus}"
  end

  # we'll represent state as a state machine
end
