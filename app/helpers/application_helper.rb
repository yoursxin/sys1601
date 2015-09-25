module ApplicationHelper
	# Returns the full title on a per-page basis.
	def full_title(page_title)
		base_title = "Ruby on Rails Tutorial Sample App"
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
		when "3" then "入库退回"
		when "3" then "出库待审核"
		when "4" then "出库退回"
		when "5" then "出库"
		else "未知"
		end
	end
end