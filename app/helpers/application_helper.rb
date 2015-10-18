module ApplicationHelper
	# Returns the full title on a per-page basis.
	def full_title(page_title)
		base_title = "SYS1601"
		if page_title.empty?
			base_title
		else
			"#{base_title} | #{page_title}"
		end
	end
	def get_kcztdesc(kczt)
		case kczt
		when "0" then "录入"
		when "1" then "入库待审核"
		when "2" then "入库"
		when "3" then "入库申请退回"
		when "4" then "出库待审核"
		when "5" then "出库"
		when "6" then "出库申请退回"
		else "未知"
		end
	end
	def get_zjztdesc(kczt)
		case kczt
		when "0" then "录入"
		when "1" then "入金待审核"
		when "2" then "入金"
		when "3" then "入金申请退回"
		when "4" then "结清待审核"
		when "5" then "结清"
		when "6" then "结清申请退回"
		else "未知"
		end
	end
end