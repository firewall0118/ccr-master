class ReportsController < ApplicationController

  def termination
    @families = Family.includes(contracts: [:funder]).denied

    respond_to do |format|
      format.html
      format.csv { send_data @families.to_csv }
      format.pdf do
        render pdf: format("Termination report - #{Date.today}"),
               template: 'reports/termination',
               layout: 'layouts/pdf.html.slim',
               page_size: 'Letter',
               header: {
                 spacing: 2
               },
               footer: {
                 spacing: 10
               },
               margin: {
                 top: 20,
                 bottom: 25
               }
      end
    end
  end

  def redetermination_due
    params[:year] = Date.today.year if params[:year].nil?
    params[:month] = Date.today.month if params[:month].nil?

    date = Date.new(params[:year].to_i, params[:month].to_i)

    @families = Family.includes(contracts: [:funder]).where(redetermination_due_date: date.beginning_of_month..date.end_of_month)

    respond_to do |format|
      format.html
      format.csv { send_data @families.redetermination_due_csv }
      format.pdf do
        render pdf: format("Termination report - #{Date.today}"),
               template: 'reports/termination',
               layout: 'layouts/pdf.html.slim',
               page_size: 'Letter',
               header: {
                 spacing: 2
               },
               footer: {
                 spacing: 10
               },
               margin: {
                 top: 20,
                 bottom: 25
               }
      end
    end
  end

  def reimbursement
    params[:year] = Date.today.year if params[:year].nil?
    params[:month] = Date.today.month if params[:month].nil?

    date = Date.new(params[:year].to_i, params[:month].to_i)

    @payouts = Payout.includes(:provider_attendance, contract: [:provider, :child, :funder, :family])
                     .where(created_at: date.beginning_of_month..date.end_of_month)

    respond_to do |format|
      format.html
      format.csv { send_data reimbursement_csv(params[:year].to_i, params[:month].to_i) }
      format.pdf do
        render pdf: format("Reimbursement report - #{Date.today}"),
               template: 'reports/reimbursement',
               layout: 'layouts/pdf.html.slim',
               page_size: 'Letter',
               header: {
                 spacing: 2
               },
               footer: {
                 spacing: 10
               },
               margin: {
                 top: 20,
                 bottom: 25
               }
      end
    end
  end

  def provider_payment
    params[:year] = Date.today.year if params[:year].nil?
    params[:month] = Date.today.month if params[:month].nil?

    attendances = ProviderAttendance.closed.where(year: params[:year], month: params[:month])
    @providers = Provider.includes(:county).where(id: attendances.map(&:provider_id)).order(:name)

    respond_to do |format|
      format.html
      format.csv { send_data @providers.to_csv({}, {payment_report: true}) }
      format.pdf do
        render pdf: format("Provider payment report - #{Date.today}"),
               template: 'reports/provider_payment',
               layout: 'layouts/pdf.html.slim',
               page_size: 'Letter',
               header: {
                 spacing: 2
               },
               footer: {
                 spacing: 10
               },
               margin: {
                 top: 20,
                 bottom: 25
               }
      end
    end
  end

  def provider_payment_due
    params[:year] = Date.today.year if params[:year].nil?
    params[:month] = Date.today.month if params[:month].nil?
    attendances = ProviderAttendance.pending.where(year: params[:year], month: params[:month])
    @contracts = Contract.where(id: attendances.pluck(:contract_id))

    respond_to do |format|
      format.html
      format.csv { send_data provider_payment_due_csv(@contracts) }
      format.pdf do
        render pdf: format("Provider Payment Due report - #{Date.today}"),
               template: 'reports/provider_payment_due',
               layout: 'layouts/pdf.html.slim',
               page_size: 'Letter',
               header: {
                 spacing: 2
               },
               footer: {
                 spacing: 10
               },
               margin: {
                 top: 20,
                 bottom: 25
               }
      end
    end
  end

  def children_per_provider
    @providers = Provider.includes(children: [:family]).all.order(:name)
    respond_to do |format|
      format.html
      format.csv { send_data @providers.children_per_provider }
      format.pdf do
        render pdf: format("Children per provider Report - #{Date.today}"),
               template: 'reports/children_per_provider',
               layout: 'layouts/pdf.html.slim',
               page_size: 'Letter',
               header: {
                 spacing: 2
               },
               footer: {
                 spacing: 10
               },
               margin: {
                 top: 20,
                 bottom: 25
               }
      end
    end
  end

  def fiscal_year
    @contracts = Contract.in_fiscal_year.includes(:child, :family).order(:child_id)

    respond_to do |format|
      format.html
      format.csv { send_data @contracts.fiscal_year }
      format.pdf do
        render pdf: format("Fiscal Year Report - #{Date.today}"),
               template: 'reports/fiscal_year',
               layout: 'layouts/pdf.html.slim',
               page_size: 'Letter',
               header: {
                 spacing: 2
               },
               footer: {
                 spacing: 10
               },
               margin: {
                 top: 20,
                 bottom: 25
               }
      end
    end
  end

  def family_average_income
    if params[:start_date].present? && params[:end_date].present?
      @funders = Funder.where("created_at >= ?", params[:start_date].to_date)
                       .where("created_at <= ?", params[:end_date].to_date)
    elsif params[:start_date].present?
      @funders = Funder.where("created_at >= ?", params[:start_date].to_date)
    elsif params[:end_date].present?
      @funders = Funder.where("created_at <= ?", params[:end_date].to_date)
    else
      @funders = Funder.all
    end

    respond_to do |format|
      format.html
      format.csv { send_data @funders.to_csv }
      format.pdf do
        render pdf: format("Family Average Income Report - #{Date.today}"),
               template: 'reports/family_average_income',
               layout: 'layouts/pdf.html.slim',
               page_size: 'Letter',
               header: {
                 spacing: 2
               },
               footer: {
                 spacing: 10
               },
               margin: {
                 top: 20,
                 bottom: 25
               }
      end
    end
  end

  def funding_source_historical_contract
    if params[:funder_id].nil?
      @funder = Funder.first
    else
      @funder = Funder.find(params[:funder_id])
    end

    @funding_cycles = @funder.funding_cycles
    respond_to do |format|
      format.html
      format.csv { send_data @funding_cycles.to_csv }
      format.pdf do
        render pdf: format("Funding Source Historical Contract Report - #{Date.today}"),
               template: 'reports/funding_source_historical_contract',
               layout: 'layouts/pdf.html.slim',
               page_size: 'Letter',
               header: {
                 spacing: 2
               },
               footer: {
                 spacing: 10
               },
               margin: {
                 top: 20,
                 bottom: 25
               }
      end
    end
  end

  def balance_remaining_per_funder
    @funders = Funder.includes(:funding_cycles)

    params[:year] = Date.today.year if params[:year].nil?
    if params[:year].present? && params[:month].present?
      params[:month] = Date.today.month if params[:month].nil?

      date = Date.new(params[:year].to_i, params[:month].to_i)

      payouts = Payout.where(created_at: date.beginning_of_month..date.end_of_month)
      @funders.where(funding_cycles: {id: payouts.map(&:id)})
    end

    respond_to do |format|
      format.html
      format.csv { send_data @funders.balance_sheet }
      format.pdf do
        render pdf: format("Balance remaining per funder report - #{Date.today}"),
               template: 'reports/balance_remaining_per_funder',
               layout: 'layouts/pdf.html.slim',
               page_size: 'Letter',
               header: {
                 spacing: 2
               },
               footer: {
                 spacing: 10
               },
               margin: {
                 top: 20,
                 bottom: 25
               }
      end
    end
  end

  def payouts
    @payouts = Payout.includes(:provider_attendance, contract: [:provider, :funder, :child])
  end

  private
  def reimbursement_csv(year, month)
    CSV.generate do |csv|
      header = [
        "Vendor ID",
        "Provider Name",
        "Child Name",
        "Date of Service",
        "Funder",
        "Paid At",
        "Eligibility Activity",
        "Care Level",
        "Care Provided",
        "Provider Rate",
        "Parent Fee",
        "Gross Reimb.",
        "Less Fees",
        "Net Reimb."
      ]
      total_amount = total_parent_fee = total_subsidy = 0

      payouts_by_funder = @payouts.group_by{|p| p.funding_cycle_id }

      payouts_by_funder.each do |grouped|
        funding_cycle = FundingCycle.find(grouped[0])
        csv << []
        csv << [
          "Funder Name",
          funding_cycle.funder.name
        ]
        csv << []
        csv << header
        sub_total_amount = sub_total_parent_fee = sub_total_subsidy = 0
        grouped[1].each do |payout|
          next if payout.provider_attendance.nil?
          contract = payout.contract
          year = payout.provider_attendance.year
          month = payout.provider_attendance.month
          csv << [
            contract.provider.vendor_number,
            contract.provider.name,
            contract.child.full_name,
            Date::MONTHNAMES[month],
            contract.funder.abbreviation,
            payout.created_at.to_date,
            contract.days_attended(year, month),
            contract.child.age_group.try(:name),
            contract.is_full_time ? "FT" : "PT",
            view_context.number_to_currency(contract.weekly_rate),
            view_context.number_to_currency(contract.weekly_parent_fee),
            view_context.number_to_currency(contract.total_amount(year, month)),
            view_context.number_to_currency(contract.total_parent_fee(year, month)),
            view_context.number_to_currency(contract.total_subsidy(year, month))
          ]
          sub_total_amount += contract.total_amount(year, month)
          sub_total_parent_fee += contract.total_parent_fee(year, month)
          sub_total_subsidy += contract.total_subsidy(year, month)
        end
        csv << [
          nil,
          nil,
          nil,
          nil,
          nil,
          nil,
          nil,
          nil,
          nil,
          nil,
          'TOTAL',
          view_context.number_to_currency(sub_total_amount),
          view_context.number_to_currency(sub_total_parent_fee),
          view_context.number_to_currency(sub_total_subsidy)
        ]
        total_amount += sub_total_amount
        total_parent_fee += sub_total_parent_fee
        total_subsidy += sub_total_subsidy
      end
      csv << []
      csv << [
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        'TOTAL',
        view_context.number_to_currency(total_amount),
        view_context.number_to_currency(total_parent_fee),
        view_context.number_to_currency(total_subsidy)
      ]
    end
  end

  def provider_payment_due_csv(contracts)
    CSV.generate do |csv|
      header = [
        "Vendor ID",
        "Provider Name",
        "Child Name",
        "Date of Service",
        "Funder",
        "Eligibility Activity",
        "Care Level",
        "Care Provided",
        "Provider Rate",
        "Parent Fee",
        "Gross Reimb.",
        "Less Fees",
        "Net Reimb."
      ]
      total_amount = total_parent_fee = total_subsidy = 0
      csv << header
      sub_total_amount = sub_total_parent_fee = sub_total_subsidy = 0
      contracts.each do |contract|
        year = params[:year].to_i
        month = params[:month].to_i
        csv << [
          contract.provider.vendor_number,
          contract.provider.name,
          contract.child.full_name,
          Date::MONTHNAMES[month],
          contract.funder.abbreviation,
          contract.days_attended(year, month),
          contract.child.age_group.try(:name),
          contract.is_full_time ? "FT" : "PT",
          view_context.number_to_currency(contract.weekly_rate),
          view_context.number_to_currency(contract.weekly_parent_fee),
          view_context.number_to_currency(contract.total_amount(year, month)),
          view_context.number_to_currency(contract.total_parent_fee(year, month)),
          view_context.number_to_currency(contract.total_subsidy(year, month))
        ]
        sub_total_amount += contract.total_amount(year, month)
        sub_total_parent_fee += contract.total_parent_fee(year, month)
        sub_total_subsidy += contract.total_subsidy(year, month)
      end
      csv << [
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        'TOTAL',
        view_context.number_to_currency(sub_total_amount),
        view_context.number_to_currency(sub_total_parent_fee),
        view_context.number_to_currency(sub_total_subsidy)
      ]
      total_amount += sub_total_amount
      total_parent_fee += sub_total_parent_fee
      total_subsidy += sub_total_subsidy
    end
  end
end
