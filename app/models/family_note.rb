class FamilyNote < ActiveRecord::Base
  extend Enumerize

  belongs_to :family
  belongs_to :user

  enumerize :category, in: %w(eligibility award_letter provider_letter inner),
                       scope: true,
                       predicates: { prefix: true }

  validates :content, :family_id, :user_id, presence: true

  default_scope { order("created_at ASC") }
  
  def self.by_period(start_date, end_date)
    where("created_at BETWEEN ? AND ?", start_date, end_date)
  end
end
