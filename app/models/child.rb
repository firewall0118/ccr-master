class Child < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :family, counter_cache: true
  has_many :contracts, dependent: :destroy
  has_one  :current_contract, -> { earlist }, class_name: 'Contract'
  has_many :providers, through: :contracts

  # Trigger family callbacks
  before_save { family.save }

  scope :by_family, -> family_id { where(family_id: family_id) }
  scope :awaiting, -> { joins(:contracts).where("COUNT(contracts.id) = 0") }

  validates :first_name,
            :last_name,
            :date_of_birth,
            :gender,
            :race, presence: true

  validates_date :date_of_birth, before: :today

  validates :weekly_maximum_payout, numericality: { greater_than: 0, less_than: 500000}, allow_blank: true

  def full_name
    "#{first_name} #{last_name}"
  end

  # Calculates the age of the child for the current date
  def current_age
    dob = date_of_birth
    now = Time.now.utc.to_date
    now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
  end

  def current_months
    dob = date_of_birth
    now = Time.now.utc.to_date
    months = (now.year - dob.year) * 12 + now.month - dob.month - (now.day >= dob.day ? 0 : 1)
    months == 0 ? 1 : months
  end

  def age_group
    AgeGroup.where('(min <= :months OR min IS NULL) AND (max >= :months OR max IS NULL)',
      months: current_months).first
  end
end
