class PjmrsController < ApplicationController

	def index
		@pjmrs = Pjmr.paginate(page: params[:page])
	end

	def delete_multiple 
		@pjmrs = Pjmr.paginate(page: params[:page])
		Pjmr.find(params[pjmr_ids[]]).destroy
		flash[:success] ="删除成功"
		redirect_to pjmrs_url
	end 
end