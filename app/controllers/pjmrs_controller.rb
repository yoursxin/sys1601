class PjmrsController < ApplicationController

	def index
		@pjmrs = Pjmr.paginate(page: params[:page])
	end
end