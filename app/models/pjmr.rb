class Pjmr < ActiveRecord::Base

	validates :ph, presence: true
	


	def self.import(file)
		colnmHash = Hash["票号","ph","出票人","cpr","承兑人","cdr","承兑行行号","cdrkhh","汇票金额","pmje","出票日","cprq","票据到期日","pmdqrq","起息日","qxrq","利率%","zrll","天数","jxts","到期日","jxdqrq"]
		spreadsheet = open_spreadsheet(file)
		header = spreadsheet.row(1)
		
		Pjmr.transaction do
		  (2..spreadsheet.last_row).each do |i|			
			  row = Hash[[header, spreadsheet.row(i)].transpose].slice(*colnmHash.keys)
			
			  #把key置换成列名			
			  row.transform_keys! {|key| key = colnmHash[key]}
			  pjmr = Pjmr.new
			  pjmr.attributes = row.merge("kczt"=>"0","lrsj"=>Time.now)
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
end
