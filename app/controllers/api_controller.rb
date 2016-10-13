class ApiController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json

  def render_success extra={}
    render json: extra
  end

  def render_error entity=nil
    if entity.nil?
      render json: {}, status: :unprocessable_entity
    else
      render json: entity.errors.full_messages, status: :unprocessable_entity
    end
  end

  # Set root to false as this helps standardize things for the front-end.
  # No need to repeat in each controller call.
  def default_serializer_options
    {
      root: false
    }
  end

  # api_scopes is a wrapper to make has_scopes work properly with Rails 4
  # and Active Records finicky use of .to_a vs. all sometimes.
  def api_scopes(klass)
    scope = apply_scopes(klass)
    scope.respond_to?(:to_a) ? scope.to_a : scope.all
  end
end
