class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:show, :edit, :update]
  before_action :admin_user, only: :destroy

  load_and_authorize_resource

  def index
    @users = User.paginate(page: params[:page])
  end
  def show
	  @user = User.find(params[:id])   
  end
  def new
	@user = User.new
  end
  def create
	@user = User.new(user_params) # Not the final implementation!
	if @user.save
	  flash[:success] = "用户创建成功!"
	  redirect_to users_path
	else
	  render 'new'
	end
  end
  def edit    

  end
  def adminEdit
    @user = User.find(params[:id])
  end
  def adminUpdate
     @user = User.find(params[:id])
     if @user.update_attributes(adminUser_params)
      flash[:success] = "用户设置已更新"     
      redirect_to users_path
    else
      render 'adminEdit'
    end
  end
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "用户设置已更新"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "用户已删除."
    redirect_to users_url
  end 

  private
  def adminUser_params
    params.require(:user).permit(:password,:name,:email,
    :password_confirmation, roles: []) 
  end
   def user_params
    params.require(:user).permit(:password,:name,:email,
    :password_confirmation) 
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end
  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

end