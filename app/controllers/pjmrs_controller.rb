class PjmrsController < ApplicationController

	def index		
		wh=genFindCon params
		wh['lrr']=current_user.name			
		@pjmrs = Pjmr.where(wh).order("updated_at desc").paginate(page: params[:page])
	end

	#录入清单
	def lrIndex		
		wh=genFindCon params
		wh['kczt'] = ["0","3"]  #录入状态
		wh['lrr'] = current_user.name		
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
		wh['kczt'] = ["2","6"]  #入库	或 出库申请退回	
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
		redirect_to lrIndex_pjmrs_url
	rescue ActiveRecord::RecordNotFound
		logger.error "查找票据失败"+$!.to_s
		flash[:error] = "未选择或选择的票据不存在"
		redirect_to lrIndex_pjmrs_url
	end	

	def import
		Pjmr.import(params[:file], current_user.name)
		redirect_to lrIndex_pjmrs_url, notice: "导入成功"
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
		if params[:cksq_btn]
			@pjmrs = Pjmr.find(params[:pjmr_ids])
		elsif params[:cksqdel_btn]
			Pjmr.plcksqdel params[:pjmr_ids], current_user.name
			redirect_to rkIndex_pjmrs_path
		end			
	end

 	#出库批量申请
 	def ckplsq
 		if params[:pjmr_ids].blank?
 			flash[:error] = "未选择或选择的票据不存在"
 			redirect_to rkIndex_pjmrs_path
 		else
 			Pjmr.transaction do
 				params[:pjmr_ids].each do |id|
 					pjmr = Pjmr.find(id)
 					pjmr.kczt = '4'
 					pjmr.create_pjmc(pjmc_params)
 					pjmr.pjmc.ph = pjmr.ph
 					pjmr.pjmc.cksqr= current_user.name
 					pjmr.pjmc.cksqsj=Date.today					
 					pjmr.save!  
 				end
 			end
 			redirect_to rkIndex_pjmrs_path
 		end
 	end

 	def pjmc_params
 		params.require(:pjmc).permit(:ph, :pch, :khmc, :zmrq, :txlx, :jjrjt, :ydjt, :jxts, :jxdqrq, :zcll\
 			, :zclx, :ssje, :khjlmc, :dabh)
 	end 

 	#出库审核
 	def cksh
 		if params[:cksh_btn]
 			Pjmr.plcksh(params[:pjmr_ids],current_user.name)
 			flash[:success] = "出库成功"
 		elsif params[:cksqth_btn]
 			Pjmr.plcksqth(params[:pjmr_ids],current_user.name)
 			flash[:success] = "出库申请退回成功"
 		end
 		redirect_to ckdshIndex_pjmrs_path
 	end

end