class MembersController < ApplicationController
    # Set the current project before any action
    before_action :set_project
    before_action :find_project
    before_action :find_member, only: [:destroy]
  
    # GET /projects/:project_id/members
    # Retrieve all members of the current project
    def index
      @members = @project.members
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

    def destroy 
       # Check if the current user is an admin and is not deleting themselves
      if current_user.admin? && current_user != @member.user
        @member.destroy
        flash[:notice] = "Member successfully removed from the project."
      else
        flash[:alert] = "You do not have permission to remove this member."
      end
      redirect_to project_members_path(@current_project)
    end

    private

    def set_project
      @project = Project.find(params[:project_id])
    end

    def find_project
      @project = Project.find(params[:project_id])
    end

    def find_member
      @member = @project.members.find(params[:id])
    end
end
  

  
    