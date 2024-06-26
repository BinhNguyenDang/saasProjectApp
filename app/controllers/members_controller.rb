class MembersController < ApplicationController
    # Set the current project before any action
    before_action :set_current_project
  
    # GET /projects/:project_id/members
    # Retrieve all members of the current project
    def index
      @members = @current_project.members
    end
  
    # POST /projects/:project_id/members/invite
    # Invite a new member to the current project
    def invite
      email = params[:email]
      # Redirect if no email is provided
      return redirect_to project_members_path(@current_project), alert: "No email provided" if email.blank?

      if current_user.admin? #check if the current user is an admin 
        user = User.find_by(email: email)
        if user.nil?

          # Invite the user if they do not exist
          user = User.invite!({ email: email }, current_user) # current_user will be set as invited_by
          # Redirect if the email is invalid
          return redirect_to project_members_path(@current_project), alert: "Email Invalid" unless user.persisted?
        end
  
      # Check if the user is already a member of the project
        if user.members.find_by(project: @current_project).nil?
          # Add the user as a member with specified roles
          user.members.create(project: @current_project, roles: { admin: false, editor: true })
          redirect_to project_members_path(@current_project), notice: "#{email} invited!"
        else
          redirect_to project_members_path(@current_project), alert: "#{email} is already a member!"
        end
      else  
        redirect_to project_members_path(@current_project), alert: "You are not authorized to invite members!"
      end
    end
end
  

  
    