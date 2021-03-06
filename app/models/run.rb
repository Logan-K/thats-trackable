class Run < ActiveRecord::Base
  has_many :runners
  belongs_to :planned_run

  #Catches the user trying to add duplicate dates per runner
  validates_uniqueness_of :date, :scope => :runner_id
end
