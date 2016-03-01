class BeerClubsController < ApplicationController
  before_action :set_beer_club, only: [:show, :edit, :update, :destroy]
  before_action :ensure_that_signed_in, except: [:index, :show]

  # GET /beer_clubs
  # GET /beer_clubs.json
  def index
    @beer_clubs = BeerClub.all
  end

  # GET /beer_clubs/1
  # GET /beer_clubs/1.json
  def show
    confirmed_memberships = Membership.confirmed.where(beer_club_id: @beer_club.id)
    @confirmed_members = []
    confirmed_memberships.each do |c|
      @confirmed_members << User.find_by(id: c.user_id)
    end
    pending_memberships = Membership.pending.where(beer_club_id: @beer_club.id)
    @pending_members = []
    pending_memberships.each do |c|
      @pending_members << User.find_by(id: c.user_id)
    end
    if current_user && @beer_club.members.exclude?(current_user)
      @membership = Membership.new
      @membership.user = current_user
      @membership.beer_club = @beer_club
    end
    if current_user && @beer_club.members.include?(current_user)
      @membership = Membership.find_by(user_id: current_user.id, beer_club_id:@beer_club.id)
    end
  end

  # GET /beer_clubs/new
  def new
    @beer_club = BeerClub.new
  end

  # GET /beer_clubs/1/edit
  def edit
  end

  # POST /beer_clubs
  # POST /beer_clubs.json
  def create
    @beer_club = BeerClub.new(beer_club_params)

    respond_to do |format|
      if @beer_club.save
        Membership.create beer_club_id: @beer_club.id, user_id: current_user.id, pending: false
        format.html { redirect_to @beer_club, notice: 'BeerClub was successfully created.' }
        format.json { render :show, status: :created, location: @beer_club }
      else
        format.html { render :new }
        format.json { render json: @beer_club.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /beer_clubs/1
  # PATCH/PUT /beer_clubs/1.json
  def update
    respond_to do |format|
      if @beer_club.update(beer_club_params)
        format.html { redirect_to @beer_club, notice: 'BeerClub was successfully updated.' }
        format.json { render :show, status: :ok, location: @beer_club }
      else
        format.html { render :edit }
        format.json { render json: @beer_club.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /beer_clubs/1
  # DELETE /beer_clubs/1.json
  def destroy
    if is_admin
      @beer_club.destroy
    end
    respond_to do |format|
      format.html { redirect_to beer_clubs_url, notice: 'BeerClub was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def confirm_membership
      membership = Membership.find_by(beer_club_id: params[:beer_club_id], user_id: params[:user_id])
      membership.update_attribute :pending, (false)

      member = User.find_by(id: params[:user_id]).username

      redirect_to :back, notice:"Membership confirmed to #{member}"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_beer_club
      @beer_club = BeerClub.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def beer_club_params
      params.require(:beer_club).permit(:name, :founded, :city)
    end
end
