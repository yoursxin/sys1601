module ApplicationHelper
	# Returns the full title on a per-page basis.
	KCZTDESC = {"0" => "录入","1" => "入库待审核","2" => "入库"\
		, "3" => "入库申请退回", "4" => "出库待审核", "5" => "出库"\
		, "6" => "出库申请退回"}

	ZJZTDESC = {"0" => "录入","1" => "入账待审核","2" => "入账"\
		, "3" => "入账申请退回", "4" => "结清待审核", "5" => "结清"\
		, "6" => "结清申请退回"}

	def full_title(page_title)
		base_title = "SYS1601"
		if page_title.empty?
			base_title
		else
			"#{base_title} | #{page_title}"
		end
	end

	def get_kcztkeys
		KCZTDESC.keys
    end

    def get_kcztdesc(kczt)
    	KCZTDESC[kczt]
    end

    def get_zjztkeys
		ZJZTDESC.keys
    end

    def get_zjztdesc(zjzt)
    	ZJZTDESC[zjzt]
    end	
	
	def getZjye
		Zjtz.where("zt in ('2','4','6')").sum(:je)
	end
	def getPjye
		 Pjmr.where("kczt in ('2','4','6')").sum(:sfje)
	end
	def genZjpjyeBar
		zjye = getZjye
		pjye = getPjye
		classname='bg-primary'
		if zjye == pjye
			classname='bg-success'
		end
		'<p  class='+classname+'>' \
		+'  库存票据实付金额总计：'+number_to_currency(pjye,unit: '')+'元'\
		+'，资金余额总计：'  +number_to_currency(zjye,unit: '')+'元'\
		+'，差额：'  +number_to_currency(pjye-zjye,unit: '')+'元'\
		+'</p>'

	end
end