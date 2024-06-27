class AuthorizedController < ApplicationController
    # Set the current project and authorize the member before any action
    before_action :set_current_project
    before_action :authorize_member
  
    private
  
    # Finds the project using the project_id parameter and sets it to @current_project
    def set_current_project
      membership = current_user.members.find_by(project_id: params[:project_id])
      @current_project = membership.project if membership
      unless @current_project
        flash[:alert] = 'You are nor a memeber of this project'
        redirect_to projects_path
      end
    end
  
    # Checks if the current user is a member of the current project
    # Redirects to the root path with an alert if the user is not a member
    def authorize_member
      unless @current_project.users.include?(current_user)
        redirect_to root_path, alert: 'You are not a member'
      end
    end
  end
  