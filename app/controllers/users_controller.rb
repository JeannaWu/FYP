class UsersController < ApplicationController
	before_action :authenticate_user!, except: [:index, :show]
  before_action :admin_user,     only: :destroy
  before_action :find_user,      only: :destroy
	def show
    
		@user = User.where(:name => params[:name]).first
    @user = User.find(params[:id])
    @posts = @user.posts.paginate(:page => 1, :per_page => 36)
       
	end
  

  def index

    @users = User.paginate(page: params[:page], per_page: 30)
  end

  

  def new
     @user = User.new
     
    
  end

  def create
  @user = User.create(user_params )  
  
  end

	 def posts
    @user = User.where(:name => params[:name]).first

    @current_page = params[:page].present? ? params[:page] : 1
    @posts = @user.posts.page(@current_page).per(20).order('created_at DESC')

    @title = "#{@user.name} All Posts"
  
  end
  def edit
  	@user = current_user
    @user.build_account unless @user.account.present?
  end
  

     def destroy
          @user.destroy
          flash[:success] = "User deleted"
          redirect_to users_url
        
       end

    def update_avatar
    @user = current_user
    if params[:user].present?
      if @user.update_without_password(user_params)
        flash[:success] = 'Setting avatar successfully'
        redirect_to settings_path + '#avatar'
      else
        flash[:error] = 'Setting avatar unsuccessfully'
        render :edit
      end
    else
      redirect_to settings_path + '#avatar', :notice => 'Select your avatar'
    end
  end

  def follow
    @user = User.find(params[:id])
    current_user.follow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
end


   def unfollow
    @user = User.find(params[:id])
    current_user.stop_following(@user)
   respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
       
end


    def following
          @title = "Following"
          @user  = User.find(params[:id])
          @users = @user.follows_by_type(@user).paginate(page: params[:page], per_page: 20)
         render 'show_follow'
        end

      #  def joining
       #   @title = "Joining"
        #  @user  = User.find(params[:id])
         # @clubs = @user.ffollowing_by_type(@club).paginate(page: params[:page])
         #render 'show_join'
        #end

      def followers
          @title = "Followers"
          @user  = User.find(params[:id])
          @users = @user.followers.paginate(page: params[:page], per_page: 20)
          render 'show_follow'
       end

  

	private
  def find_user
    @user = User.find(params[:id])
    
  end
  def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
  
	def professional_user_params
      params.require(:user).permit(:name, :email, :password, :profession, :introduction,
                                   :password_confirmation, :gender,:avatar)
    end
    def user_params
      params.require(:user).permit(:name, :email, :password, 
                                   :password_confirmation, :gender,:avatar)
    end
end
