class QueriesController < ApplicationController
	@@names = ApplicationRecord.execQuery("select distinct name from camoen.complaint order by name");

	def index
		render :layout => "landing_page"
	end

	def dashboard
	end
	
	def query_directory
		#@@names = ApplicationRecord.execQuery("select distinct name from camoen.complaint order by name");
		@names = @@names
		# @names = ApplicationRecord.execQuery("select distinct name from camoen.complaint order by name");
		# Replace above line with below for faster load times during development (if needed)
		# @names = ApplicationRecord.execQuery("select distinct name from camoen.complaint where rownum <= 5 order by name");
	end
	

	def complaint_rankings
		@results = ApplicationRecord.execQuery("select distinct name, type, submitted_via from camoen.complaint where rownum <= 50");
		# @results = c.execute("select * from camoen.complaint where rownum <= 10")
		# while r = @results.fetch()
		# 	puts r.join(',')
		# end
		# @results.close

		
		# results.each do |result|
		#   	puts result[0]
		# end

		# for result in @results
		# 	result.name #|  posting.time | posting.salary 
		# end

		# def index
		#   	@telephone_records = TelephoneRecord.all
		# end
		
	end

	# Forms for Custom User Query
	def create
	 	#@tags = params[:flag]
	end

	def custom_search
		# Custom Search Logic using parameters
		query = "select"
		num = 0
		
		# If company name(s) are selected
		#TODO: Fix company names with an & in them so the & is escaped
		companies = ""
		if (!params[:cname].blank?)
			num = 1
			params[:cname].each do |i|
				if num == 1
					companies += "where name = '"
				else
					companies += "or name = '"
				end
				companies += @@names[Integer(i[0])]["name"]
				companies += "' "
				num = num + 1
			end
		puts companies
		end

		# If product type is selected
		product = ""
		prodnum = 0
		if (!params[:type].blank?)
		 	if num < 1
		 		product += "where "
		 		num = num + 1
		 	end
			if params[:type].key?("1")
		 		if num > 1
					product += "and "
		 		end
				product += "type in (select type from camoen.bank_account) "
		 		num = num + 1
		 		prodnum = prodnum + 1
		 	end
		 	if params[:type].key?("2")
		 		if num > 1
		 			if prodnum > 0
		 				product += "or "
		 			else
						product += "and "
					end
		 		end
				product += "type in (select type from camoen.payday_loan) "
		 		num = num + 1
		 		prodnum = prodnum + 1
		 	end
		 	if params[:type].key?("3")
		 		if num > 1
					if prodnum > 0
		 				product += "or "
		 			else
						product += "and "
					end
		 		end
				product += "type in (select type from camoen.credit_card) "
		 		num = num + 1
		 		prodnum = prodnum + 1
		 	end
		 	if params[:type].key?("4")
		 		if num > 1
					if prodnum > 0
		 				product += "or "
		 			else
						product += "and "
					end
		 		end
				product += "type in (select type from camoen.credit_reporting) "
		 		num = num + 1
		 		prodnum = prodnum + 1
		 	end
		 	if params[:type].key?("5")
		 		if num > 1
					if prodnum > 0
		 				product += "or "
		 			else
						product += "and "
					end
		 		end
				product += "type = 'Debt collection' "
		 		num = num + 1
		 		prodnum = prodnum + 1
		 	end
		 	if params[:type].key?("6")
		 		if num > 1
					if prodnum > 0
		 				product += "or "
		 			else
						product += "and "
					end
		 		end
				product += "type in (select type from camoen.money_transfer) "
		 		num = num + 1
		 		prodnum = prodnum + 1
		 	end
		 	if params[:type].key?("7")
		 		if num > 1
					if prodnum > 0
		 				product += "or "
		 			else
						product += "and "
					end
		 		end
				product += "type = 'Mortgage' "
		 		num = num + 1
		 		prodnum = prodnum + 1
		 	end
		 	if params[:type].key?("8")
		 		if num > 1
					if prodnum > 0
		 				product += "or "
		 			else
						product += "and "
					end
		 		end
				product += "type in (select type from camoen.prepaid_card) "
		 		num = num + 1
		 		prodnum = prodnum + 1
		 	end
		 	if params[:type].key?("9")
		 		if num > 1
					if prodnum > 0
		 				product += "or "
		 			else
						product += "and "
					end
		 		end
				product += "type = 'Student Loan' "
		 		num = num + 1
		 		prodnum = prodnum + 1
		 	end
		 	if params[:type].key?("10")
		 		if num > 1
					if prodnum > 0
		 				product += "or "
		 			else
						product += "and "
					end
		 		end
				product += "type in (select type from camoen.virtual_currency) "
		 		num = num + 1
		 		prodnum = prodnum + 1
		 	end
		 	if params[:type].key?("11")
		 		if num > 1
					if prodnum > 0
		 				product += "or "
		 			else
						product += "and "
					end
		 		end
				product += "type = 'Other financial service' "
		 		num = num + 1
		 		prodnum = prodnum + 1
		 	end
		puts product
		end

		# If demographic is selected
		demo = ""
		demnum = 0
		if (!params[:demo].blank?)
		 	if num < 1
		 		demo += "where "
		 		num = num + 1
		 	end
		 	if params[:demo].key?("1")
		 		if num > 1
					demo += "and "
		 		end
		 		demo += "("
		 		if params[:demo]["1"] == "1"
					demo += "tag like '%Older%' "
			 	else
					demo += "tag not like '%Older%' "
			 	end
			 	num = num + 1
			 	demnum = demnum + 1
		 	end
			if params[:demo].key?("2")
		 		if num > 1
					demo += "and "
		 		end
		 		if demnum < 1
		 			demo += "("
		 		end
		 		if params[:demo]["2"] == "1"
					demo += "tag like '%Service%' "
			 	else
					demo += "tag not like '%Service%' "
			 	end
			 	num = num + 1
			 	demnum = demnum + 1
		 	end
		 	if params[:demo].key?("3")
		 		if num > 1
		 			if demnum > 0
		 				demo += "or "
		 			else
						demo += "and ("
					end
		 		end
				demo += "tag is null"
		 		num = num + 1
		 	end
		 	demo += ") "
		 	puts demo
		 end



	end

	def product_rankings
	end

	def timeliness_rankings
	end

	def dispute_rankings
	end


end
