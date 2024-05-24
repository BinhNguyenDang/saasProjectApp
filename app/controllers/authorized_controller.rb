class AuthorizedController < ApplicationController
    before_action :set_current_project
    before_action :authorize_member

    private
    
    def set_current_project
        @current_project = Project.find(params[:project_id])
      end
    
      def authorize_member
        return redirect_to root_path, alert: 'You are not a member' unless @current_project.users.include? current_user
      end
    
    end