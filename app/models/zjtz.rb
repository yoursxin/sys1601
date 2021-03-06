class Zjtz < ActiveRecord::Base
	validates :ll, numericality: {greater_than_or_equal_to: 0}, :allow_nil => true
	validates :jxts, numericality: true, :allow_nil => true
	validates :lx, numericality: {greater_than_or_equal_to: 0}, :allow_nil => true
	validates :csll, numericality: {greater_than_or_equal_to: 0}, :allow_nil => true
	validates :csjxts, numericality: {greater_than_or_equal_to: 0}, :allow_nil => true
	validates :cslx, numericality: {greater_than_or_equal_to: 0}, :allow_nil => true
	validates :je, numericality: {greater_than_or_equal_to: 0}, :allow_nil => true
	
	class InvalidZtException  < RuntimeError
	end 
	
	#批量入金申请
	def self.plrjsq( ids, usid)
		Zjtz.transaction do
			ids.each do |id|
				zjtz = Zjtz.find(id)
				zjtz.zt = '1'
				zjtz.rjsqr = usid
				zjtz.rjsqsj = Time.now
				zjtz.save!
			end
		end
	end

	#批量录入删除
	def self.pllrdel (ids)			
		Zjtz.transaction do
		  Zjtz.find(ids).each  do |zjtz|
		  	  raise InvalidZtException, '只有录入或入金申请退回状态才能进行删除' if zjtz.zt !='0' && zjtz.zt !='3' 
			  zjtz.destroy
		  end
		end	
	end

	#批量入金申请退回
	def self.plrjsqth( ids, usid)
		Zjtz.transaction do
			ids.each do |id|
				zjtz = Zjtz.find(id)
				if !(('1' == zjtz.zt) || ('2' == zjtz.zt && zjtz.rjshsj && Date.today.to_s == zjtz.rjshsj.to_s[0,10] ))
					raise InvalidZtException, '该笔记录不是入账待审核或当日入账状态，不能进行退回：'+zjtz.bh
				end
				zjtz.zt = '3'
				zjtz.rjshr = usid
				zjtz.rjshsj = Time.now				
				zjtz.save!
			end
		end
	end

	#批量入金审核
	def self.plrjsh( ids, usid)
		Zjtz.transaction do
			ids.each do |id|
				zjtz = Zjtz.find(id)
				zjtz.zt = '2'
				zjtz.rjshr = usid
				zjtz.rjshsj = Time.now				
				zjtz.save!
			end
		end
		
	end

	#批量出金审核
	def self.plcjsq( ids, usid)
		Zjtz.transaction do
			ids.each do |id|				
				zjtz = Zjtz.find(id)
 				zjtz.zt = '4'  					
 				zjtz.cjsqr= usid
 				zjtz.cjsqsj=Time.now				
 				zjtz.save!  
			end
		end
	end

	#批量出金申请删除
	def self.plcjsqdel (ids, usid)
		Zjtz.transaction do
			Zjtz.find(ids).each do |zjtz|
				raise InvalidZtException, "只有结清申请退回状态才能进行删除"  if zjtz.zt != '6' 
				zjtz.zt = '2'	
				zjtz.cjsqr= usid
 				zjtz.cjsqsj=Time.now						
				zjtz.save!
			end
		end
	end

	#批量出金申请退回
	def self.plcjsqth(ids, usid) 
		Zjtz.transaction do |id|
			ids.each do |id|
				zjtz = Zjtz.find(id)
				if !(('4' == zjtz.zt) || ('5' == zjtz.zt && zjtz.cjshsj && Date.today.to_s == zjtz.cjshsj.to_s[0,10] ))
					raise InvalidZtException, '该笔记录不是结清待审核或当日结清状态，不能进行退回：'+zjtz.bh
				end
				zjtz.zt = '6'
				zjtz.cjshr = usid
				zjtz.cjshsj = Time.now				
				zjtz.save!
			end
		end
	end

	#批量出金审核
	def self.plcjsh(ids, usid)
		Zjtz.transaction do
			ids.each do |id|
				zjtz = Zjtz.find(id)
				zjtz.zt = '5'
				zjtz.cjshr = usid
				zjtz.cjshsj = Time.now				
				zjtz.save!
			end
		end
	end
end
