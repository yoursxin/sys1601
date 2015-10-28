class ZjtzsController < ApplicationController

	before_action :signed_in_user
	load_and_authorize_resource

	def index
		wh = genFindCon(params)
		@zjtzs = Zjtz.where(wh).order("updated_at desc").paginate(page: params[:page])		
		
		
	end
	#入金申请
	def rjsq
		if params[:lr_btn]
			redirect_to new_zjtz_path
		elsif params[:del_btn]			
			Zjtz.pllrdel params[:zjtz_ids]
			flash[:success] ="删除成功"
			redirect_to lrIndex_zjtzs_path
		elsif params[:rjsq_btn]
			Zjtz.plrjsq(params[:zjtz_ids], current_user.name)
			flash[:success] = "入金申请成功"
			redirect_to lrIndex_zjtzs_path
		end
		
	rescue ActiveRecord::RecordNotFound
		logger.error "查找记录败"+$!.to_s
		flash[:error] = "未选择或选择的记录不存在"
		redirect_to lrIndex_zjtzs_path		
	end

	def lrIndex
		wh = genFindCon(params)
		wh['zt'] = ["0","3"]  #录入状态
		wh['lrr'] = current_user.name		
		@zjtzs = Zjtz.where(wh).order("updated_at desc").paginate(page: params[:page])
	end

	#入金待审核清单，进行入金
	def rjdshIndex		
		wh=genFindCon params
		wh['zt'] = "1"  #入金待审核		
		@zjtzs = Zjtz.where(wh).paginate(page: params[:page])
	end

	#入金清单
	def rjIndex		
		wh=genFindCon params
		wh['zt'] = ["2","6"]  #入金状态		
		@zjtzs = Zjtz.where(wh).paginate(page: params[:page])
	end
	
	#入金审核
	def rjsh		
		if params[:rjsh_btn]
			Zjtz.plrjsh(params[:zjtz_ids], current_user.name)
			flash[:success] = "入金成功"
		elsif params[:rjsqth_btn]	
			Zjtz.plrjsqth(params[:zjtz_ids], current_user.name)
			flash[:success] = "入金申请退回成功"
		end	

		redirect_to rjdshIndex_zjtzs_path
	end

	def new 
		@zjtz = Zjtz.new		
	end
	def create
		@zjtz = Zjtz.new(zjtz_params)
		@zjtz.zt = '0'
		@zjtz.lrr = current_user.name
		@zjtz.lrsj = Time.now
		if @zjtz.save
			flash[:sucess] = '添加成功'
			redirect_to  lrIndex_zjtzs_path
		else
			render 'new'
		end
	end

	#出金批量编辑
	def cjpledit
		if params[:cjsq_btn]
			@zjtzs = Zjtz.find(params[:zjtz_ids])
		elsif params[:cjsqdel_btn]
			Zjtz.plcjsqdel params[:zjtz_ids], current_user.name
			flash[:sucess] = '结清申请删除成功'
			redirect_to rjIndex_zjtzs_path
		end			
	end

 	#出金批量申请
 	def cjsq
 		if params[:zjtz_ids].blank?
 			flash[:error] = "未选择或选择的记录不存在"
 			redirect_to rjIndex_zjtzs_path
 		else
 			Zjtz.transaction do
 				params[:zjtz_ids].each do |id|
 					zjtz = Zjtz.find(id)
 					zjtz.zt = '4'
 					zjtz.update(zjtz_params) 					
 					zjtz.cjsqr= current_user.name
 					zjtz.cjsqsj=Time.now				
 					zjtz.save!  
 				end
 			end
 			flash[:success] = "结清申请成功"
 			redirect_to rjIndex_zjtzs_path


 		end
 	end

 	#出金待审核清单，进行出库
	def cjdshIndex		
		wh=genFindCon params
		wh['zt'] = "4"  #出库待审核		
		@zjtzs = Zjtz.where(wh).paginate(page: params[:page])
	end

	#出金审核
 	def cjsh
 		if params[:cjsh_btn] 			
 			Zjtz.plcjsh(params[:zjtz_ids],current_user.name) 
 			flash[:success] = "结清成功"
 		elsif params[:cjsqth_btn]
 			Zjtz.plcjsqth(params[:zjtz_ids],current_user.name)
 			flash[:success] = "结清申请退回成功"
 		end
 		redirect_to cjdshIndex_zjtzs_path
 	end
	

	def zjtz_params
 		params.require(:zjtz).permit(:bh, :khmc, :cpms, :je, :biz, :csqxrq, :csdqrq \
 			, :csll, :csjxts, :cslx, :khjlmc, :bz, :dabh, :jqbh, :qxrq, :dqrq, :ll \
 			, :jxts, :lx)
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


end
