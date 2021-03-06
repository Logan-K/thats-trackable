class RunsController < ApplicationController
  before_action :set_run, only: [:show, :edit, :update, :destroy]
  before_action :get_runner


  def index
    if @runner
      @run = @runner.runs
    else
      @run = Run.all
    end

  end

  def get_runner
    @runner = Runner.find_by_id params[:runner_id]
  end

  def show
  end

  def new
    @run = Run.new
  end

  def edit
  end

  def update
    respond_to do |format|
      if @run.update(run_params)
        format.html { redirect_to "/runners/#{current_runner.id}/today", notice: 'Run was successfully updated. '}
        format.json { render :show, status: :ok, location: @run }
      else
        format.html { render :edit }
        format.json { render json: @run.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
    @run = Run.new(run_params)

    respond_to do |format|
      if @run.save
        format.html {redirect_to @run, notice: 'Run was successfully created.' }
        format.json {render :show, status: :created, locations: @run }
      else
        format.html { render :edit }
        format.json { render json: @run.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @run.destroy
    respond_to do |format|
      format.html { redirect_to runs_url, notice: 'Run was successfully destroyed. ' }
      format.json { head :no_content }
    end
  end

  private
  def set_run
     @run = Run.find(params[:id])
   # @run = Run.find(params[:runs_id])
  end

  def run_params
    params.require(:run).permit(:runner_id, :date, :training_plan, :progress)
  end
end