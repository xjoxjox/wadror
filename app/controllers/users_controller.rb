class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :froze_and_activate]

  # GET /users
  # GET /users.json
  def index
    @users = User.includes(:beers, :ratings).all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    confirmed_memberships = Membership.confirmed.where(user_id: @user.id)
    @confirmed_clubs = []
    confirmed_memberships.each do |c|
      @confirmed_clubs << BeerClub.find_by(id: c.beer_club_id)
    end

    pending_memberships = Membership.pending.where(user_id: @user.id)
    @pending_clubs = []
    pending_memberships.each do |c|
      @pending_clubs << BeerClub.find_by(id: c.beer_club_id)
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.update_attribute :admin, false
    @user.update_attribute :froze, false
    respond_to do |format|
      if @user.save
        format.html { redirect_to signin_path, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if user_params[:username].nil? and @user == current_user and @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    session.destroy if current_user == @user
    @user.destroy if current_user == @user
    respond_to do |format|
      format.html { redirect_to signin_path, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def froze_and_activate
    if current_user.admin
      user = User.find(params[:id])
      user.update_attribute :froze, (not user.froze)

      new_status = user.froze? ? "frozen" : "activated"

      redirect_to :back, notice:"users account has been #{new_status}"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username, :password, :password_confirmation, :admin, :froze)
    end
end
