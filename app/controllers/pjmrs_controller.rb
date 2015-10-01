class PjmrsController < ApplicationController

	#录入清单
	def index		
		wh=genFindCon params
		wh['kczt'] = ["0","3"]  #录入状态		
		@pjmrs = Pjmr.where(wh).paginate(page: params[:page])
	end

	#根据录入清单，进行入库申请
	def rksqIndex		
		wh=genFindCon params
		wh['kczt'] = "0"  #录入状态		
		@pjmrs = Pjmr.where(wh).paginate(page: params[:page])
	end

	#入库待审核清单，进行入库
	def rkdshIndex		
		wh=genFindCon params
		wh['kczt'] = "1"  #入库待审核		
		@pjmrs = Pjmr.where(wh).paginate(page: params[:page])
	end
	
	#入库审核
	def rksh		
		if params[:rksh_btn]
			Pjmr.plrksh(params[:pjmr_ids], current_user.name)
			flash[:success] = "入库成功"
		elsif params[:rksqth_btn]	
			Pjmr.plrksqth(params[:pjmr_ids], current_user.name)
			flash[:success] = "入库申请退回成功"
		end	

		redirect_to rkdshIndex_pjmrs_url
	end


	#入库清单，进行出库申请
	def rkIndex		
		wh=genFindCon params
		wh['kczt'] = "2"  #入库		
		@pjmrs = Pjmr.where(wh).paginate(page: params[:page])
	end

	#出库待审核清单，进行出库
	def ckdshIndex		
		wh=genFindCon params
		wh['kczt'] = "4"  #出库待审核		
		@pjmrs = Pjmr.where(wh).paginate(page: params[:page])
	end

	#入库申请
	def rksq 		
		if params[:del_btn]			
			Pjmr.pllrdel params[:pjmr_ids]
			flash[:success] ="删除成功"
		elsif params[:rksq_btn]
			Pjmr.plrksq(params[:pjmr_ids], current_user.name)
			flash[:success] = "入库申请成功"
		end			
		redirect_to pjmrs_url
	rescue ActiveRecord::RecordNotFound
		logger.error "查找票据失败"+$!.to_s
		flash[:error] = "未选择或选择的票据不存在"
		redirect_to pjmrs_url
	end	

	def import
		Pjmr.import(params[:file])
		redirect_to root_url, notice: "导入成功"
	end 

	def genFindCon(params)
		wh={}		
		params.keys.each do |key|
			val = params[key]
			wh[key[2,key.length-1]] = val if !val.blank? && key.index("f_")==0
		end
		logger.debug "wh: "+wh.to_s
		wh
	end 

	#出库批量编辑
	def ckpledit
		@pjmrs = Pjmr.find(params[:pjmr_ids])
	end

 	def ckplsq
 		if params[:pjmr_ids].blank?
 			flash[:error] = "未选择或选择的票据不存在"
 			redirect_to rkIndex_pjmrs_path
 		else
 			Pjmr.transaction do
 				params[:pjmr_ids].each do |id|

 					
 				end
 			end

 		end

 	end

	
end