class ProviderRate < ActiveRecord::Base

  belongs_to :provider

  # validates :effective_date, presence: true
  # validates :end_date, date: { after: :effective_date } , :allow_nil => true
  validates :part_time_toddler_weekly_rate,
            :part_time_infant_weekly_rate,
            :part_time_school_weekly_rate,
            :part_time_preschool_weekly_rate,
            :part_time_sibling_discount_flat_amount,
            :full_time_toddler_weekly_rate,
            :full_time_infant_weekly_rate,
            :full_time_school_weekly_rate,
            :full_time_preschool_weekly_rate,
            :full_time_sibling_discount_flat_amount,
            numericality: { greater_than: 0 }, allow_nil: true

  validates :full_time_sibling_discount_percentage , numericality: { only_integer: true,
                              greater_than_or_equal_to: 1,
                              less_than_or_equal_to: 100 }, allow_nil: true, allow_blank: true

  validates :part_time_sibling_discount_percentage , numericality: { only_integer: true,
                              greater_than_or_equal_to: 1,
                              less_than_or_equal_to: 100 }, allow_nil: true, allow_blank: true


  # validates :effective_date, :end_date, :overlap => { :scope => "provider_id",  exclude_edges: ["end_date"] }

  validate :full_time_discount_or_percent

  def full_time_discount_or_percent

    if has_sibling_discounts?

      if ( full_time_sibling_discount_flat_amount_cents.blank?  && full_time_sibling_discount_percentage.blank? )
          errors.add(:full_time_sibling_discount_flat_amount_cents,"Please add a percentage or fixed discount")
      end

      if ( part_time_sibling_discount_flat_amount_cents.blank?  && part_time_sibling_discount_percentage.blank? )
          errors.add(:part_time_sibling_discount_flat_amount_cents,"Please add a percentage or fixed discount")
      end
    end
  end

  def current?
    return true
    (effective_date < Date.today) && (Date.today  < end_date )
  end
end