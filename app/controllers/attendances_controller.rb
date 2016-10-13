class AttendancesController < ApplicationController
  # Phase 2: index will assign Attendance models, these are not saved yet.
  def index
    provider_ids = (params[:provider_ids] || '').split(',')
    @providers   = Provider.where(id: provider_ids).order(:name)

    @ccr = Struct.new(:name, :address, :location).new(
      ChildcareResource.company_name, ChildcareResource.company_address,
      ChildcareResource.company_location
    )
  end

  def new
    # nothing here, just render template, data fetched by JSON
  end

  # CSS @media print was padding content
  def print
    index
    render :index, layout: 'simple'
  end
end
