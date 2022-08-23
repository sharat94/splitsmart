class Api::V1::GroupsController < Api::ApiController

  def index
    groups = @current_user.groups

    render json: groups
  end

end
