class PlannedRunsController < ApplicationController
  before_action :set_planned_run, only: [:show, :edit, :update, :destroy]

  def index
    @planned_runs = PlannedRun.all
  end

  def show
  end

  def new
    @planned_run = PlannedRun.new
  end

  def edit
  end

  def create
    @planned_run = PlannedRun.new(planned_run_params)
    respond_to do |format|
      if @planned_run.save
        format.html { redirect_to @planned_run, notice: 'Planned Run was successfully create. ' }
        format.json { render :show, status: :created, location: @planned_run }
      else
        format.html{ render :new }
        format.json { render json: @planned_run.errors, status: :unprocessable_entity }
      end
    end

    #Add all "Planned_runs" for runners in this new group. (Planned_runs turn into runs)
    Runner.where(group_id: @planned_run[:group_id]).find_each do |runner|
      run = Run.new
      run.runner_id = runner.id
      run.date = @planned_run.date
      run.training_plan = @planned_run.training_plan
      run.planned_run_id = @planned_run.id
      run.save
    end
  end


  def update
    respond_to do |format|
      if @planned_run.update(planned_run_params)
        format.html { redirect_to @planned_run, notice: 'Planned Run was successfully updated. '}
        format.json { render :show, status: :ok, location: @planned_run }
      else
        format.html { render :edit }
        format.json { render json: @planned_run.errors, status: :unprocessable_entity }
      end
    end

    #Update all runs if Planned_run is changed
    Run.where(planned_run_id: @planned_run.id).find_each do |run|
      run.date = @planned_run.date
      run.training_plan = @planned_run.training_plan
      run.save
    end
  end

  def destroy
     @planned_run.destroy
     respond_to do |format|
       format.html { redirect_to planned_runs_url, notice: 'Planned Run was successfully deleted. '}
       format.json { head :no_content }
     end
  end

  private
  def set_planned_run
    @planned_run = PlannedRun.find(params[:id])
  end

  def planned_run_params
    params.require(:planned_run).permit(:date, :group_id, :training_plan, :progress)
  end
end