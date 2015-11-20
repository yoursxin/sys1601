class PjmrsController < ApplicationController

	before_action :signed_in_user
	load_and_authorize_resource 
	
	def index		
		@pjmrs = genFindCon params
		@pjmrs = @pjmrs.where({"kczt" =>  params["kczt_ids"]})	 if params["kczt_ids"].present?		
		@pjmrs = @pjmrs.order("updated_at desc, id desc")
		
		if params[:commit] == "下载"
	      response.headers['Content-Disposition'] = 'attachment; filename=pjmx.xls'
		  render "index.xls.erb"
		else 
		  @pjmrs = @pjmrs.paginate(page: params[:page])
		end

		#logger.debug(">>>>>  cookies[:_name]" + cookies[:_name].to_s)
				
	end

	#根据选择的票据id，返回统计信息
	def seltj		

		ids = []
		if  params[:selpjckids]
			ids =  params[:selpjckids].split(",")
		end		

		sfje = Pjmr.where({"id" => ids}).sum(:pmje)
		respond_to do |formate|
			formate.js {render plain: "已选择票据数量："+ids.size.to_s+" 笔，票面金额总计："+sfje.to_s+" 元"}
		end	
		
	end


	#录入清单
	def lrIndex	
		@pjmrs = genFindCon params
		@pjmrs = @pjmrs.where('kczt' =>  ["0","3"], 'lrr' =>  current_user.email)
		@pjmrs = @pjmrs.order("updated_at desc, id desc")	
		@pjmrs = @pjmrs.paginate(page: params[:page])
	end

	#根据录入清单，进行入库申请
	def rksqIndex		
		@pjmrs = genFindCon params
		@pjmrs = @pjmrs.where('kczt' => "0")
		@pjmrs = @pjmrs.order("updated_at desc, id desc")	
		@pjmrs = @pjmrs.paginate(page: params[:page])
		
	end

	#入库待审核清单，进行入库
	def rkdshIndex		
		@pjmrs = genFindCon params
		@pjmrs = @pjmrs.where('kczt' => "1") #入库待审核		
		@pjmrs = @pjmrs.order("updated_at desc, id desc")	
		@pjmrs = @pjmrs.paginate(page: params[:page])
	end
	
	#入库审核
	def rksh_old
	  if params[:pjmr_ids].blank?
			flash[:warning] = "请选择要操作的记录"			
	  else		
		if params[:rksh_btn]
			Pjmr.plrksh(params[:pjmr_ids], current_user.email)
			flash[:success] = "入库成功"
		elsif params[:rksqth_btn]	
			Pjmr.plrksqth(params[:pjmr_ids], current_user.email)
			flash[:success] = "入库申请退回成功"
		end
	  end	
	  redirect_to rkdshIndex_pjmrs_url
	end

	def rksh
	  #logger.debug("rksh cookies[:selpjckids]:"+cookies[:selpjckids])
	  if cookies[:selpjckids].blank?
			flash[:warning] = "请选择要操作的记录"			
	  else
	  	ids = cookies[:selpjckids].split(",")		
		if params[:rksh_btn]
			Pjmr.plrksh(ids, current_user.email)
			flash[:success] = "入库成功"
		elsif params[:rksqth_btn]	
			Pjmr.plrksqth(ids, current_user.email)
			flash[:success] = "入库申请退回成功"
		end
		cookies.delete(:selpjckids)	
	  end	
	  redirect_to rkdshIndex_pjmrs_url
	end


	#入库清单，进行出库申请
	def rkIndex		
		@pjmrs = genFindCon params
		@pjmrs = @pjmrs.where('kczt' =>  ["2","6"])  #入库	或 出库申请退回	
		@pjmrs = @pjmrs.order("updated_at desc, id desc")	
		@pjmrs = @pjmrs.paginate(page: params[:page])

	end

	#出库待审核清单，进行出库
	def ckdshIndex		
		@pjmrs = genFindCon params
		@pjmrs = @pjmrs.where('kczt' =>  "4")  #出库待审核	
		@pjmrs = @pjmrs.order("updated_at desc, id desc")	
		@pjmrs = @pjmrs.paginate(page: params[:page])
	end

	#入库申请
	def rksq_old 
		
		if params[:pjmr_ids].blank?
			flash[:warning] = "请选择要操作的记录"			
		else
		  if params[:del_btn]			
			Pjmr.pllrdel params[:pjmr_ids]
			flash[:success] ="删除成功"
		  elsif params[:rksq_btn]
			Pjmr.plrksq(params[:pjmr_ids], current_user.email)
			flash[:success] = "入库申请成功"
		  end		  
		end
		redirect_to lrIndex_pjmrs_url
	rescue ActiveRecord::RecordNotFound
		logger.error "查找票据失败"+$!.to_s
		flash[:warning] = "未选择或选择的票据不存在"
		redirect_to lrIndex_pjmrs_url
	end

	#入库申请
	def rksq 
		
		#logger.debug("cookies[:selpjckids]:"+cookies[:selpjckids])

		if cookies[:selpjckids].blank?
			flash[:warning] = "请选择要操作的记录"			
		else
		  ids = cookies[:selpjckids].split(",")
		  if params[:del_btn]			
			Pjmr.pllrdel ids
			flash[:success] ="删除成功"
		  elsif params[:rksq_btn]
			Pjmr.plrksq(ids, current_user.email)
			flash[:success] = "入库申请成功"
		  end
		  cookies.delete(:selpjckids)		  
		end
		redirect_to lrIndex_pjmrs_url
	rescue ActiveRecord::RecordNotFound
		logger.error "查找票据失败"+$!.to_s
		flash[:warning] = "未选择或选择的票据不存在"
		redirect_to lrIndex_pjmrs_url
	end		

	def import
		Pjmr.import(params[:file], current_user.email)
		redirect_to lrIndex_pjmrs_url, notice: "导入成功"
	end 

	

	#出库批量编辑
	def ckpledit
		if cookies[:selpjckids].blank?
			flash[:warning] = "请选择要操作的记录"
			redirect_to rkIndex_pjmrs_path
		else
		  ids = cookies[:selpjckids].split(",")
		  if params[:cksq_btn]
			@pjmrs = Pjmr.find(ids)
			
		  elsif params[:cksqdel_btn]
			Pjmr.plcksqdel ids, current_user.email
			flash[:sucess] = '出库申请删除成功'
			redirect_to rkIndex_pjmrs_path
		  end
		  
		end			
	end

 	#出库批量申请
 	def ckplsq
 		if cookies[:selpjckids].blank?
 			flash[:warning] = "未选择或选择的票据不存在" 			
 		else
 			ids = cookies[:selpjckids].split(",")
 			Pjmr.transaction do
 				ids.each do |id|
 					pjmr = Pjmr.find(id)
 					pjmr.kczt = '4'
 					pjmr.create_pjmc(pjmc_params)
 					pjmr.pjmc.ph = pjmr.ph
 					pjmr.pjmc.cksqr= current_user.email
 					pjmr.pjmc.cksqsj=Time.now				
 					pjmr.save!  
 				end
 			end
 			cookies.delete(:selpjckids) 			
 		end
 		redirect_to rkIndex_pjmrs_path
 	end

 	

 	#出库审核
 	def cksh
 		if cookies[:selpjckids].blank?
			flash[:warning] = "请选择要操作的记录"			
		else
 		  ids = cookies[:selpjckids].split(",")
 		  if params[:cksh_btn]
 			Pjmr.plcksh(ids,current_user.email)
 			flash[:success] = "出库成功"
 		  elsif params[:cksqth_btn]
 			Pjmr.plcksqth(ids,current_user.email)
 			flash[:success] = "出库申请退回成功"
 		  end
 		  cookies.delete(:selpjckids)
 		end
 		redirect_to ckdshIndex_pjmrs_path
 	end

 	private
 	def pjmc_params
 		params.require(:pjmc).permit(:ph, :pch, :khmc, :zmrq, :txlx, :jjrjt, :ydjt, :jxts, :jxdqrq, :zcll\
 			, :zclx, :ssje, :khjlmc, :dabh)
 	end 

 	def genFindCon(params)
		wh={}		
		params.keys.each do |key|
			val = params[key]
			wh[key[2,key.length-1]] = val if !val.blank? && key.index("f_")==0			
		end
		pjmrResult = Pjmr.where(wh)
		pjmrResult = pjmrResult.where("cpr like ? ","%#{params['fl_cpr']}%") if params["fl_cpr"].present?
		pjmrResult = pjmrResult.where("qxrq >= ? ", params["fr_lqxrq"]) if params["fr_lqxrq"].present?
		pjmrResult = pjmrResult.where("qxrq <= ? ", params["fr_gqxrq"]) if params["fr_gqxrq"].present?
		pjmrResult = pjmrResult.where("jxdqrq >= ? ", params["fr_ldqrq"]) if params["fr_ldqrq"].present?
		pjmrResult = pjmrResult.where("jxdqrq <= ? ", params["fr_gdqrq"]) if params["fr_gdqrq"].present?
		pjmrResult = pjmrResult.where("pmje >= ? ", params["fr_lpmje"]) if params["fr_lpmje"].present?
		pjmrResult = pjmrResult.where("pmje <= ? ", params["fr_gpmje"]) if params["fr_gpmje"].present?

		logger.debug "wh: "+wh.to_s
		pjmrResult
	end 



end