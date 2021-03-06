class RunnersController < ApplicationController
  before_action :set_runner, only: [:show, :edit, :update, :destroy]

  # GET /runners
  # GET /runners.json
  def index
    @runners = Runner.all
  end

  # GET /runners/1
  # GET /runners/1.json
  def show
  end

  # GET /runners/new
  def new
    @runner = Runner.new
  end

  # GET /runners/1/edit
  def edit
  end

  # POST /runners
  # POST /runners.json
  def create
    @runner = Runner.new(runner_params)

    respond_to do |format|
      if @runner.save
        log_in @runner
        format.html { redirect_to "/runners/#{@runner.id}/today", notice: 'Profile was successfully created.' }
        format.json { render :show, status: :created, location: @runner }
      else
        format.html { render :new }
        format.json { render json: @runner.errors, status: :unprocessable_entity }
      end
    end

    #Assigning all existing plans to runner as individual runs
    PlannedRun.where(group_id: @runner.group_id).find_each do |plan|
      run = Run.new
      run.runner_id = @runner.id
      run.date = plan.date
      run.training_plan = plan.training_plan
      run.planned_run_id = plan.id
      run.save
    end
  end

  # PATCH/PUT /runners/1
  # PATCH/PUT /runners/1.json
  def update
    #Change Runs if group is updated on runner
    #Tests current group_id to group_id param passed in
    if @runner.group_id.to_s != runner_params[:group_id]
      Run.where(runner_id: @runner.id).find_each do |oldRun|
        #Must destroy old runs for this runner
        oldRun.destroy
      end
      #Add new runs depending on group
      PlannedRun.where(group_id: runner_params[:group_id]).find_each do |plan|
        run = Run.new
        run.runner_id = @runner.id
        run.date = plan.date
        run.training_plan = plan.training_plan
        run.planned_run_id = plan.id
        run.save
      end
    end

    respond_to do |format|
      if @runner.update(runner_params)
        format.html { redirect_to @runner, notice: 'Runner was successfully updated.' }
        format.json { render :show, status: :ok, location: @runner }
      else
        format.html { render :edit }
        format.json { render json: @runner.errors, status: :unprocessable_entity }
      end
    end


  end

  # DELETE /runners/1
  # DELETE /runners/1.json
  def destroy
    @runner.destroy
    respond_to do |format|
      format.html { redirect_to runners_url, notice: 'Runner was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def today
    @today = Date.today
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_runner
      @runner = Runner.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def runner_params
      params.require(:runner).permit(:name, :group_id, :role, :username, :password)
    end
end
