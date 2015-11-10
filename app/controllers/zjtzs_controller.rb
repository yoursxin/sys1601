class ZjtzsController < ApplicationController

	before_action :signed_in_user
	load_and_authorize_resource

	def index
		wh = genFindCon(params)
		wh["zt"] = params["zjzt_ids"] if params["zjzt_ids"].present?
		@zjtzs = Zjtz.where(wh).order("updated_at desc")

		if params["commit"] == "下载"
		  response.headers['Content-Disposition'] = 'attachment; filename=zjtz.xls'
		  render "index.xls.erb"
		else 
		  @zjtzs = @zjtzs.paginate(page: params[:page])
		end	

				
	end
	#入账申请
	def rjsq
		if params[:lr_btn]
			redirect_to new_zjtz_path
		elsif params[:del_btn]			
		  if params[:zjtz_ids].blank?
	        flash[:warning] = "请选择要操作的记录"
	      else
			Zjtz.pllrdel params[:zjtz_ids]
			flash[:success] ="删除成功"
		  end
		  redirect_to lrIndex_zjtzs_path
		elsif params[:rjsq_btn]
		  if params[:zjtz_ids].blank?
	        flash[:warning] = "请选择要操作的记录"
	      else
			Zjtz.plrjsq(params[:zjtz_ids], current_user.email)
			flash[:success] = "入账申请成功"
		  end
		  redirect_to lrIndex_zjtzs_path
		end
		
	rescue ActiveRecord::RecordNotFound
		logger.error "查找记录败"+$!.to_s
		flash[:warning] = "未选择或选择的记录不存在"
		redirect_to lrIndex_zjtzs_path		
	end

	def lrIndex
		wh = genFindCon(params)
		wh['zt'] = ["0","3"]  #录入状态
		wh['lrr'] = current_user.email		
		@zjtzs = Zjtz.where(wh).order("updated_at desc").paginate(page: params[:page])
	end

	#入账待审核清单，进行入账
	def rjdshIndex		
		wh=genFindCon params
		wh['zt'] = "1"  #入账待审核		
		@zjtzs = Zjtz.where(wh).paginate(page: params[:page])
	end

	#入账清单
	def rjIndex		
		wh=genFindCon params
		wh['zt'] = ["2","6"]  #入账状态		
		@zjtzs = Zjtz.where(wh).paginate(page: params[:page])
	end
	
	#入账审核
	def rjsh		
	  if params[:zjtz_ids].blank?
	    flash[:warning] = "请选择要操作的记录"
	  else
		if params[:rjsh_btn]
			Zjtz.plrjsh(params[:zjtz_ids], current_user.email)
			flash[:success] = "入账成功"
		elsif params[:rjsqth_btn]	
			Zjtz.plrjsqth(params[:zjtz_ids], current_user.email)
			flash[:success] = "入账申请退回成功"
		end	
	  end
      redirect_to rjdshIndex_zjtzs_path
	end

	def new 
		@zjtz = Zjtz.new	
		@zjtz.csqxrq = Date.today
		@zjtz.biz = '人民币'		
	end
	def create
		@zjtz = Zjtz.new(zjtz_params)
		@zjtz.zt = '0'
		@zjtz.lrr = current_user.email
		@zjtz.lrsj = Time.now
		if @zjtz.save!
			flash[:sucess] = '添加成功'
			redirect_to  lrIndex_zjtzs_path		
		end
		rescue ActiveRecord::RecordInvalid
			flash[:warning] = "添加失败,"+$!.to_s
			render 'new'

	end

	#出金批量编辑
	def cjpledit
	  if params[:zjtz_ids].blank?
	    flash[:warning] = "请选择要操作的记录"
	  else
		if params[:cjsq_btn]
			@zjtzs = Zjtz.find(params[:zjtz_ids])
			@zjtz = Zjtz.new					
			@zjtz.ll =  (@zjtzs.presence) [0].csll
			@zjtz.lx =  (@zjtzs.presence) [0].cslx
			@zjtz.jxts =  (@zjtzs.presence) [0].csjxts
			@zjtz.qxrq =  (@zjtzs.presence) [0].csqxrq
			@zjtz.dqrq =  (@zjtzs.presence) [0].csdqrq

		elsif params[:cjsqdel_btn]
			Zjtz.plcjsqdel params[:zjtz_ids], current_user.email
			flash[:sucess] = '结清申请删除成功'
			redirect_to rjIndex_zjtzs_path

		end
	  end			
	end

 	#出金批量申请
 	def cjsq
 		if params[:zjtz_ids].blank?
 			flash[:warning] = "未选择或选择的记录不存在"
 			redirect_to rjIndex_zjtzs_path
 		else
 			Zjtz.transaction do
 				params[:zjtz_ids].each do |id|
 					zjtz = Zjtz.find(id)
 					zjtz.zt = '4'
 					zjtz.update(zjtz_params) 					
 					zjtz.cjsqr= current_user.email
 					zjtz.cjsqsj=Time.now				
 					zjtz.save!  
 				end
 			end
 			flash[:success] = "结清申请成功" 			
 		end
 		redirect_to rjIndex_zjtzs_path

 	

 	end

 	#出金待审核清单，进行出库
	def cjdshIndex		
		wh=genFindCon params
		wh['zt'] = "4"  #出库待审核		
		@zjtzs = Zjtz.where(wh).paginate(page: params[:page])
	end

	#出金审核
 	def cjsh
 	  if params[:zjtz_ids].blank?
	    flash[:warning] = "请选择要操作的记录"
	  else	
 		if params[:cjsh_btn] 			
 			Zjtz.plcjsh(params[:zjtz_ids],current_user.email) 
 			flash[:success] = "结清成功"
 		elsif params[:cjsqth_btn]
 			Zjtz.plcjsqth(params[:zjtz_ids],current_user.email)
 			flash[:success] = "结清申请退回成功"
 		end
 	  end
 	  redirect_to cjdshIndex_zjtzs_path
 	end
	
 	private

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
