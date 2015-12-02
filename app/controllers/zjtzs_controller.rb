class ZjtzsController < ApplicationController

	before_action :signed_in_user
	load_and_authorize_resource

	def index
		@zjtzs = genFindCon(params)
		@zjtzs = @zjtzs.where({"zt" => params["zjzt_ids"]}) if params["zjzt_ids"].present?		
		@zjtzs = @zjtzs.order("updated_at desc")

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
	rescue Zjtz::InvalidZtException
    	logger.error $!.to_s
		flash[:warning] =$!.to_s
		redirect_to rjdshIndex_zjtzs_path		
	end

	def lrIndex
		@zjtzs = genFindCon(params)
		@zjtzs = @zjtzs.where("zt" => ["0","3"], "lrr" => current_user.email)		
		@zjtzs = @zjtzs.order("updated_at desc").paginate(page: params[:page])
	end

	#入账待审核清单，进行入账
	def rjdshIndex		
		@zjtzs=genFindCon params					
		@zjtzs =@zjtzs.where("zt=? or (zt=? and cast(rjshsj as date)=? )", "1", "2", Date.today.to_s).paginate(page: params[:page])
	end

	#入账清单
	def rjIndex		
		@zjtzs=genFindCon params
		@zjtzs = @zjtzs.where("zt" =>  ["2","6"])		
		@zjtzs = @zjtzs.paginate(page: params[:page])
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
    rescue Zjtz::InvalidZtException
    	logger.error $!.to_s
		flash[:warning] =$!.to_s
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
			flash[:success] = '添加成功'
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
			begin
				Zjtz.plcjsqdel params[:zjtz_ids], current_user.email
				flash[:success] = '结清申请删除成功'
				redirect_to rjIndex_zjtzs_path
			rescue Zjtz::InvalidZtException
    			logger.error $!.to_s
				flash[:warning] =$!.to_s
				redirect_to rjIndex_zjtzs_path
			end	
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
		@zjtzs=genFindCon params		
		@zjtzs = @zjtzs.where("zt=? or (zt=? and cast(cjshsj as date)=?) ", "4", "5", Date.today.to_s).order("zt, updated_at desc, id desc").paginate(page: params[:page])

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
 	rescue Zjtz::InvalidZtException
      logger.error $!.to_s
	  flash[:warning] =$!.to_s
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
		zjtzResult = Zjtz.where(wh)
		zjtzResult = zjtzResult.where("khmc like ? ","%#{params['fl_khmc']}%") if params["fl_khmc"].present?
		logger.debug "wh: "+wh.to_s
		zjtzResult
	end 


end
