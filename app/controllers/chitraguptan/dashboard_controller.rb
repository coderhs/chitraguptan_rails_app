class Chitraguptan::DashboardController < ActionController::Base
  def index
    @variables = Chitraguptan.show_all
    @variables = @variables.select { |r| r[:key].include?(params[:search]) } if params[:search]
    @variables = @variables.each_slice(2).to_a
    render 'index', layout: nil
  end

  def update
    updated = Chitraguptan.update(params[:id], value: permit_params[:value])
    flash[:notice] = 'Key updated' if updated
    flash[:alert]  = 'Unable to update key' unless updated
    redirect_to chitraguptan_dashboard_index_path
  end

  private

  def permit_params
    params.require(:variable).permit(:value)
  end
end
