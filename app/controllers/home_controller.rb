class HomeController < ApplicationController
  def index
    @providers     = Provider.order('amount_due DESC').limit(10)
    @children      = Child.all.includes(:family)
    @children      = @children.select{|c| c.contracts.size == 0}

    @top_funders   = Funder.order('amount DESC').limit(10)
      .to_json(only: [:id, :name, :amount])
    @top_providers = Provider.where('children_count > 0')
      .order('children_count DESC').limit(10)
      .to_json(only: [:id, :name, :children_count])
  end

  def search
    p = params[:q].downcase if params[:q]
    @providers = Provider.where("lower(name) like ?", "%#{p}%")
    @funders = Funder.where("lower(name) like ?", "%#{p}%")
    @families = Family.joins(:parents)
                      .where("lower(parents.first_name) like ? or lower(parents.last_name) like ?", "%#{p}%", "%#{p}%")
    @children = Child.where("lower(first_name) like ? or lower(last_name) like ?", "%#{p}%", "%#{p}%")
  end
end
