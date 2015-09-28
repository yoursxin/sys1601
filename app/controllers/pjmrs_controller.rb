class PjmrsController < ApplicationController

	def index
		#根据输入生成查询条件
		wh={}		
		params.keys.each do |key|
			val = params[key]
			wh[key[2,key.length-1]] = val if !val.blank? && key.index("f_")==0
		end
		logger.debug "wh: "+wh.to_s
		@pjmrs = Pjmr.where(wh).paginate(page: params[:page])
	end

	def rksqIndex
		#根据输入生成查询条件
		wh={}		
		params.keys.each do |key|
			val = params[key]
			wh[key[2,key.length-1]] = val if !val.blank? && key.index("f_")==0
		end

		wh['kczt'] = "0"
		logger.debug "wh: "+wh.to_s
		@pjmrs = Pjmr.where(wh).paginate(page: params[:page])
	end

	def delete_multiple 
				
		Pjmr.transacton do
		  Pjmr.find(params[:pjmr_ids]).each  do |pjmr|
			  pjmr.destroy
		  end
		end
		flash[:success] ="删除成功"
		redirect_to pjmrs_url

	rescue ActiveRecord::RecordNotFound
		logger.error "查找票据失败"+$!.to_s
		flash[:error] = "未选择或选择的票据不存在"
		redirect_to pjmrs_url
	end

	def instockReq
		Pjmr.instockReq(params[:pjmr_ids])
		flash[:success] = "入库申请成功"
		redirect_to rksqIndex_pjmrs_url
	end

	def import
		Pjmr.import(params[:file])
		redirect_to root_url, notice: "导入成功"
	end 

	
end