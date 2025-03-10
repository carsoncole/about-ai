class HomeController < ApplicationController
  allow_unauthenticated_access only: [:index]
  before_action :resume_session, only: [:index]

  def index
    @projects = Project.order(:order, :created_at)
    @experiences = Experience.order(start_date: :desc)
  end
end
