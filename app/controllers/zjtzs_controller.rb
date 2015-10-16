class ZjtzsController < ApplicationController


	def lrsq
		@zjtzs = Zjtz.find
	end
end
