class ExperiencesController < ApplicationController
  before_action :set_experience, only: %i[ edit update destroy ]

  def new
    @experience = Experience.new
  end

  def edit
  end

  def update
    respond_to do |format|
      if @experience.update(experience_params)
        format.html { redirect_to root_path, notice: "Experience was successfully updated." }
        format.json { render :show, status: :ok, location: @experience }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @experience.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @experience.destroy!

    respond_to do |format|
      format.html { redirect_to root_path, status: :see_other, notice: "Experience was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def create
    @experience = Experience.new(experience_params)

    respond_to do |format|
      if @experience.save
        format.html { redirect_to root_path, notice: "Experience was successfully created." }
        format.json { render :show, status: :created, location: @experience }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @experience.errors, status: :unprocessable_entity }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_experience
      @experience = Experience.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def experience_params
      params.expect(experience: [ :title, :organization, :start_date, :end_date, :description, :location ])
    end


end
