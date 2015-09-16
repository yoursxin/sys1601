class PjmrsController < ApplicationController

	def index
		@pjmrs = Pjmr.paginate(page: params[:page])
	end

	def delete_multiple 
		
		Pjmr.find(params[:pjmr_ids]).each  do |pjmr|
			pjmr.destroy

		end
		flash[:success] ="删除成功"
		redirect_to pjmrs_url
	end 
end