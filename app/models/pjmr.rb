class Pjmr < ActiveRecord::Base

	has_one :pjmc, :dependent => :destroy
	validates :ph, presence: true
	validates :pmje, numericality: {greater_than_or_equal_to: 0}	 
	accepts_nested_attributes_for  :pjmc
	


	def self.import(file,usid)
		colnmHash = Hash["票号","ph","出票人","cpr","承兑人","cdr","承兑行行号","cdrkhh","汇票金额" \
			,"pmje","出票日","cprq","票据到期日","pmdqrq","起息日","qxrq","利率%","zrll","天数","jxts","到期日","jxdqrq" \
			,"pch","批次号","txlx","贴现类型", "pjlx","票据类型","jjrjt","节假日加天","ydjt","异地加天"\
			,"zrlx","转入利息", "sfje","实付金额","khmc","客户名称","cprkhh","出票人开户行","skr","收款人" \
			,"skrkhh","收款人开户行","khjlmc","客户经理","dabh","档案编号","bz","备注"]
		spreadsheet = open_spreadsheet(file)
		header = spreadsheet.row(1)
		
		Pjmr.transaction do   #使用事务
		  (2..spreadsheet.last_row).each do |i|			
			  row = Hash[[header, spreadsheet.row(i)].transpose].slice(*colnmHash.keys)
			
			  #把key置换成列名			
			  row.transform_keys! {|key| key = colnmHash[key]}
			  pjmr = Pjmr.new
			  pjmr.attributes = row.merge("kczt"=>"0","lrsj"=>Time.now,"lrr"=>usid)
			  pjmr.save!
		  end
	    end
	end

	def self.open_spreadsheet(file)
		logger.debug file.path	

		case File.extname(file.original_filename)		
		when '.xls' then Roo::Excel.new(file.path, :file_warning=>:ignore)
		when '.xlsx' then Roo::Excelx.new(file.path, :file_warning=>:ignore)
		else raise "未知的文件类型: #{file.original_filename}"
		end
	end

	#批量入库申请
	def self.plrksq( ids, usid)
		Pjmr.transaction do
			ids.each do |id|
				pjmr = Pjmr.find(id)
				pjmr.kczt = '1'
				pjmr.rksqr = usid
				pjmr.rksqsj = Time.now
				pjmr.save!
			end
		end
	end

	#批量入库审核
	def self.plrksh( ids, usid)
		Pjmr.transaction do
			ids.each do |id|
				pjmr = Pjmr.find(id)
				pjmr.kczt = '2'
				pjmr.rkshr = usid
				pjmr.rkshsj = Time.now
				pjmr.rkrq = Date.today
				pjmr.save!
			end
		end
	end

	#批量出库审核
	def self.plcksh(ids, usid)
		Pjmr.transaction do
			ids.each do |id|
				pjmr = Pjmr.find(id)
				pjmr.kczt = '5'
				pjmr.pjmc.ckshr = usid
				pjmr.pjmc.ckshsj = Time.now
				pjmr.pjmc.ckrq = Date.today
				pjmr.save!
			end
		end
	end

	#批量入库申请退回
	def self.plrksqth( ids, usid)
		Pjmr.transaction do
			ids.each do |id|
				pjmr = Pjmr.find(id)
				pjmr.kczt = '3'
				pjmr.rkshr = usid
				pjmr.rkshsj = Time.now
				pjmr.rkrq = Date.today
				pjmr.save!
			end
		end
	end

	#批量出库申请退回
	def self.plcksqth(ids, usid) 
		Pjmr.transaction do |id|
			ids.each do |id|
				pjmr = Pjmr.find(id)
				pjmr.kczt = '6'
				pjmr.pjmc.ckshr = usid
				pjmr.pjmc.ckshsj = Time.now
				pjmr.pjmc.ckrq = Date.today
				pjmr.save!
			end
		end
	end

	#批量录入删除
	def self.pllrdel (ids)			
		Pjmr.transaction do
		  Pjmr.find(ids).each  do |pjmr|
		  	  raise '只有录入或入库申请退回状态才能进行删除' if pjmr.kczt !='0' && pjmr.kczt !='3' 
			  pjmr.destroy
		  end
		end	
	end

	#批量出口申请删除
	def self.plcksqdel (ids, usid)
		Pjmr.transaction do
			Pjmr.find(ids).each do |pjmr|
				raise "只有出库申请退回状态才能进行删除"  if pjmr.kczt != '6' 
				pjmr.kczt = '2'
				pjmr.pjmc.destroy
				pjmr.save!
			end
		end
	end

end
