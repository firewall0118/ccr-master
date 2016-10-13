class Parent < ActiveRecord::Base
  has_paper_trail only: [:first_job_annual_income, :second_job_annual_income, :third_job_annual_income],
                  meta: { active_at: :income_active_at },
                  if: Proc.new { |t| t.family.status == 'redeterminated' }

  belongs_to :county
  belongs_to :family

  validates :first_name,
            :last_name,
            :race,
            :gender,
            :date_of_birth,
            :county,
            presence: true

  validates :first_job_annual_income,
            :second_job_annual_income,
            :third_job_annual_income,
            numericality: { greater_than: 0, less_than: 500000}, allow_blank: true

  validates_date :date_of_birth, before: lambda { 16.years.ago },
                                 before_message: "must be at least 16 years ago"
  default_scope { eager_load(:versions) }

  def full_name
    [last_name, first_name].join(", ")
  end

  def weekly_availability
    [
      first_job_weekly_availability,
      second_job_weekly_availability,
      third_job_weekly_availability,
    ].compact.inject(0, :+)
  end

  def annual_income(applied_at=Time.now)
    if versions.present?
      latest_version = versions.where("active_at > ?", applied_at).order(:active_at).last
      latest_data = latest_version.try(:reify)
    end
    if latest_data
      [
        latest_data.first_job_annual_income,
        latest_data.second_job_annual_income,
        latest_data.third_job_annual_income,
      ].compact.inject(0, :+)
    else
      sum_of_incomes
    end
  end

  def sum_of_incomes
    [
      first_job_annual_income,
      second_job_annual_income,
      third_job_annual_income,
    ].compact.inject(0, :+)
  end

  def current_first_job_annual_income
    if versions.present?
      latest_version = versions.where("active_at > ?", Time.now).order(:active_at).last
      latest_data = latest_version.try(:reify)
    end
    latest_data.present? ? latest_data.first_job_annual_income : first_job_annual_income
  end 

  def current_second_job_annual_income
    if versions.present?
      latest_version = versions.where("active_at > ?", Time.now).order(:active_at).last
      latest_data = latest_version.try(:reify)
    end
    latest_data.present? ? latest_data.second_job_annual_income : second_job_annual_income
  end

  def current_third_job_annual_income
    if versions.present?
      latest_version = versions.where("active_at > ?", Time.now).order(:active_at).last
      latest_data = latest_version.try(:reify)
    end
    latest_data.present? ? latest_data.third_job_annual_income : third_job_annual_income
  end 

  def city_state_zip
    "#{city}, #{state} #{zip}"
  end

  def income_active_at
    family.redetermination_active_at
  end
end
