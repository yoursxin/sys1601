class Pjmr < ActiveRecord::Base

	def self.import(file)
		spreadsheet = open_spreadsheet(file)
		header = spreadsheet.row(1)
		logger.debug header
		(2..spreadsheet.last_row).each do |i|
			
		end
	end

	def self.open_spreadsheet(file)
		logger.debug file.path
		#File.rename(file.path,file.path+File.extname(file.original_filename))
		logger.debug file.path
		logger.debug file.original_filename

		case File.extname(file.original_filename)
		when '.csv' then Csv.new(file.path, :ignore)
		when '.xls' then Roo::Excel.new(file.path, :file_warning=>:ignore)
		when '.xlsx' then Roo::Excelx.new(file.path, :file_warning=>:ignore)
		else raise "未知的文件类型: #{file.original_filename}"
		end
	end
end
