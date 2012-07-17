
class UsersController < ApplicationController

  before_filter :signed_in_user, except: [:new, :create] 
  #skip_before_filter :signed_in_user, only: :new
  before_filter :correct_user, only: [:show, :edit, :update]


  # def index
  #   @users = User.all
  # end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @habits = @user.habits.order_status_start #order("status DESC, start_date DESC") 
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Update successful"
      # remember token gets reset when saved, so resign user in
      sign_in @user
      redirect_to @user
    else
      flash.now[:error] = "Try again"
      render 'edit'
    end
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Thank you for signing up"
      redirect_to @user
    else
      render 'new'
    end
  end

  private
    def correct_user
      @user = User.find(params[:id])
      if !current_user?(@user)
        sign_out
        flash[:error] = "You can only edit your own content."
        redirect_to root_path 
      end
    end

    def signed_in_user
       redirect_to signin_path, notice: "Please sign in." unless signed_in?
    end 
end
