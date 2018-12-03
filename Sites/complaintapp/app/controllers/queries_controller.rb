class QueriesController < ApplicationController
	# Get State Abbreviations Hash
	include Variables
	@@State_list = States
	# Get Company Names
	@@names ||= ApplicationRecord.execQuery("select distinct name from camoen.complaint order by name");
	

	def index
		render :layout => "landing_page"
	end

	def dashboard
		# name = session[:user]
	 #  	pass = session[:password]
	 #  	query = "(select * from camoen.users)"
	 #  	query = ApplicationRecord.execQuery(query)
	 #  	realName = query[0]["username"]
	 #  	realPass = query[0]["password"]
	 #  	@results = session[:user]
	 #  	if (!(name == realName && pass == realPass))
	 #  		@results = 5;
	 #  		redirect_to '/login'
	 #  	end
		render :layout => "landing_page"

	end
	
	def query_directory
		@State_list = @@State_list
		#@@names = ApplicationRecord.execQuery("select distinct name from camoen.complaint order by name");
		@names = @@names
		@products = Products
		# @names = ApplicationRecord.execQuery("select distinct name from camoen.complaint order by name");
		# Replace above line with below for faster load times during development (if needed)
		# @names = ApplicationRecord.execQuery("select distinct name from camoen.complaint where rownum <= 5 order by name");
	end

	def complaint_rankings
		query = "camoen.complaint "
		dated = Company_no_dates
		query = default_company_query(dated, query)
		@results = ApplicationRecord.execQuery(query);
		@graph_data = custom_comp(@results)
		render :layout => "results"
	end

	def custom_search
		# Custom Search Logic using parameters
		num = 0
		
		# If company name(s) are selected
		companies = ""
		if (!params[:cname].blank?)
			num = 1
			params[:cname].each do |i|
				if num == 1
					companies += "where (name = '"
				else
					companies += "or name = '"
				end
				# Add logic to escape apostrophe
				apostrophe_count = @@names[Integer(i[0])]["name"].count('\'')
				if apostrophe_count > 0
					name_fix = ""
					@@names[Integer(i[0])]["name"].split('').each {|c| 
    					if c == '\''
    						name_fix += '\'\''
    					else
    						name_fix += c
    					end
					}
					companies += name_fix
				else
					companies += @@names[Integer(i[0])]["name"]
				end
				companies += "' "
				num = num + 1
			end
			companies += ") "
		end

		# If product type is selected
		product = ""
		prodnum = 0
		if (!params[:type].blank?)
		 	if num < 1
		 		product += "where ("
		 	end
		 	num = num + 1
			if params[:type].key?("1")
		 		if num > 1
					product += "and ("
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
						product += "and ("
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
						product += "and ("
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
						product += "and ("
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
						product += "and ("
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
						product += "and ("
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
						product += "and ("
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
						product += "and ("
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
						product += "and ("
					end
		 		end
				product += "type = 'Student loan' "
		 		num = num + 1
		 		prodnum = prodnum + 1
		 	end
		 	if params[:type].key?("10")
		 		if num > 1
					if prodnum > 0
		 				product += "or "
		 			else
						product += "and ("
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
						product += "and ("
					end
		 		end
				product += "type = 'Other financial service' "
		 		num = num + 1
		 		prodnum = prodnum + 1
		 	end
	 		product += ") "
		end

		# If demographic is selected
		demo = ""
		demnum = 0
		if (!params[:demo].blank?)
		 	if num < 1
		 		demo += "where "
		 	end
		 	num = num + 1
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
		 			if demnum > 0
		 				demo += "or "
		 			else
						demo += "and ("
					end
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
				demo += "tag is null "
		 		num = num + 1
		 	end
		 	demo += ") "
		end
		# If "Not Older American" and "Not Service Member" are selected
		# but "All Other Demographics" is not selected
		if (!params[:demo].blank?)
			if (params[:demo]["1"] == "2" && params[:demo]["2"] == "2" && !params[:demo].key?("3"))
				num -= 3
				demo = ""
				if num < 1
			 		demo += "where "
			 	else
			 		demo += "and "
			 	end
			 	num = num + 1
				demo += "tag is null "
			end
			# If only "Not Older American" is selected
			# but "All Other Demographics" is not selected
			if (params[:demo]["1"] == "2" && !params[:demo].key?("2") && !params[:demo].key?("3"))
				num -= 2
				demo = ""
				if num < 1
			 		demo += "where "
			 	else
			 		demo += "and "
			 	end
			 	num = num + 1
				demo += "(tag is null or tag not like '%Older%') "
			end
			# If only "Not Service Member" is selected
			# but "All Other Demographics" is not selected
			if (!params[:demo].key?("1") && params[:demo]["2"] == "2" && !params[:demo].key?("3"))
				num -= 2
				demo = ""
				if num < 1
			 		demo += "where "
			 	else
			 		demo += "and "
			 	end
			 	num = num + 1
				demo += "(tag is null or tag not like '%Service%') "
			end
		end

		 # If Submission Method is selected
		submission = ""
		subnum = 0
		if (!params[:sub].blank?)
		 	if num < 1
		 		submission += "where ("
		 	end
		 	num = num + 1
			if params[:sub].key?("1")
		 		if num > 1
					submission += "and ("
		 		end
				submission += "submitted_via = 'Email' "
		 		num = num + 1
		 		subnum = subnum + 1
		 	end
		 	if params[:sub].key?("2")
		 		if num > 1
		 			if subnum > 0
		 				submission += "or "
		 			else
						submission += "and ("
					end
		 		end
				submission += "submitted_via = 'Fax' "
		 		num = num + 1
		 		subnum = subnum + 1
		 	end
		 	if params[:sub].key?("3")
		 		if num > 1
		 			if subnum > 0
		 				submission += "or "
		 			else
						submission += "and ("
					end
		 		end
				submission += "submitted_via = 'Phone' "
		 		num = num + 1
		 		subnum = subnum + 1
		 	end
		 	if params[:sub].key?("4")
		 		if num > 1
		 			if subnum > 0
		 				submission += "or "
		 			else
						submission += "and ("
					end
		 		end
				submission += "submitted_via = 'Postal mail' "
		 		num = num + 1
		 		subnum = subnum + 1
		 	end
		 	if params[:sub].key?("5")
		 		if num > 1
		 			if subnum > 0
		 				submission += "or "
		 			else
						submission += "and ("
					end
		 		end
				submission += "submitted_via = 'Referral' "
		 		num = num + 1
		 		subnum = subnum + 1
		 	end
		 	if params[:sub].key?("6")
		 		if num > 1
		 			if subnum > 0
		 				submission += "or "
		 			else
						submission += "and ("
					end
		 		end
				submission += "submitted_via = 'Web' "
		 		num = num + 1
		 		subnum = subnum + 1
		 	end
		 	submission += ") "
		end

		# If state(s) are selected
		states = ""
		statenum = 0
		if (!params[:state].blank?)
			if num < 1
		 		submission += "where ("
		 	end
		 	num = num + 1
			params[:state].each do |i|
				if num > 1
					if statenum > 0
						states += "or "
					else
						states += "and ("
					end
				end
				states += "state = '"
				states += @@State_list[i[0]]
				states += "' "
				num = num + 1
				statenum = statenum + 1
			end
			states += ") "
		end

		# If date(s) are selected
		dates = ""
		daterange = ""
		# If both dates are selected
		if (!params[:start_date].blank? && !params[:end_date].blank?)
			if num < 1
		 		dates += "where "
		 	else
		 		dates += "and "
		 	end
		 	num = num + 1
		 	daterange += "(date_received between to_date('"
		 	daterange += params[:start_date]
		 	daterange += "', 'MM/DD/YYYY') and to_date('"
		 	daterange += params[:end_date]
		 	daterange += "', 'MM/DD/YYYY'))"
		 	dates += daterange
		# If only a start date is selected
		elsif (!params[:start_date].blank? && params[:end_date].blank?)
			if num < 1
		 		dates += "where "
		 	else
		 		dates += "and "
		 	end
	 		num = num + 1
		 	daterange += "(date_received between to_date('"
		 	daterange += params[:start_date]
		 	daterange += "', 'MM/DD/YYYY') and to_date('"
		 	daterange += "08/31/2018"
		 	daterange += "', 'MM/DD/YYYY'))"
		 	dates += daterange
		# If only an end date is selected
		elsif (params[:start_date].blank? && !params[:end_date].blank?)
			if num < 1
		 		dates += "where "
		 	else
		 		dates += "and "
		 	end
	 		num = num + 1
	 		daterange += "(date_received between to_date('"
		 	daterange += "01/01/2012"
		 	daterange += "', 'MM/DD/YYYY') and to_date('"
		 	daterange += params[:end_date]
		 	daterange += "', 'MM/DD/YYYY'))"
		 	dates += daterange
	 	# If no dates are selected
		else
			if num < 1
		 		dates += "where "
		 	else
		 		dates += "and "
		 	end
	 		num = num + 1
		 	daterange += "(date_received between to_date('"
		 	daterange += "01/01/2012"
		 	daterange += "', 'MM/DD/YYYY') and to_date('"
		 	daterange += "08/31/2018"
		 	daterange += "', 'MM/DD/YYYY'))"
		 	dates += daterange
		end

		where = companies + product + demo + submission + states + dates
		query = " (select * from camoen.complaint "
		query += where
		query += ")"
		# The base set of data to be analyzed can now be gathered from query

		tester = "select count(*) from camoen.complaint "
		tester += where
		#puts tester
		testing = ApplicationRecord.execQuery(tester);
		puts testing

		# Return query results based on selected categories
		# If product selected, but not company 
		if (params[:cname].blank? && !params[:type].blank?)
			# Dated and undated queries must be handled separately
			if (params[:start_date].blank? && params[:end_date].blank?)
				query = product_query_builder(params, query)
				@results = ApplicationRecord.execQuery(query);
				@custom_undated = custom_prod(@results)
			else
				query = product_query_builder_dated(params, query)
				@results = ApplicationRecord.execQuery(query);
				@custom_dated = custom_prod_dated(@results)
			end
		end

		# Queries with specified dates will need to be handled separately
		dated = ""
		# If no date paremeters are selected
		if (params[:start_date].blank? && params[:end_date].blank?)
			dated = Company_no_dates
		else
			# If there is at least one date parameter selected
			dated = Company_dates
		end

		# If company selected, but not product
		if (!params[:cname].blank? && params[:type].blank?)
			query = dated + Company_query_1 + query + Company_query_2 + Company_query_num + Company_query_3 + query + Company_query_4 + query + Company_query_5
			if (dated == Company_no_dates)
				query = Refine_results + query + Refine_results2
				@results = ApplicationRecord.execQuery(query);
				@custom_undated = custom_comp(@results)
			else
				@results = ApplicationRecord.execQuery(query);
				@custom_dated = custom_comp_dated(@results)
			end
		end

		# If company and product are selected
		if (!params[:cname].blank? && !params[:type].blank?)
			query = dated + Company_query_1 + query + Company_query_2 + Company_query_num + Company_query_3 + query + Company_query_4 + query + Company_query_5
			if (dated == Company_no_dates)
				query = Refine_results + query + Refine_results2
				@results = ApplicationRecord.execQuery(query);
				@custom_undated = custom_comp(@results)
			else
				@results = ApplicationRecord.execQuery(query);
				@custom_dated = custom_comp_dated(@results)
			end	
		end

		# If neither company or product are selected
		if (params[:cname].blank? && params[:type].blank?)
			query = default_custom_query(dated, query, daterange, where)
			if (dated == Company_no_dates)
				query = Refine_results + query + Refine_results2
				@results = ApplicationRecord.execQuery(query);
				@custom_undated = custom_comp(@results)
			else
				@results = ApplicationRecord.execQuery(query);
				@custom_dated = custom_comp_dated(@results)
			end
		end

		render :layout => "results"
	end

	def product_rankings
		query = "camoen.complaint "
		query = product_query_builder(params, query);
		query += "order by yr desc, type "
		@results = ApplicationRecord.execQuery(query);
		@graph_data = custom_prod(@results)
		render :layout => "results"
	end

	def timeliness_rankings
		partition_cnt = "no_cnt"
		partition_pct = "round(no_cnt/(no_cnt+yes_cnt),2)"
		@cnt_results = ApplicationRecord.execQuery(timely_query(partition_cnt));
		@pct_results = ApplicationRecord.execQuery(timely_query(partition_pct));
		@graph_data1 = get_data_grouped_by_year(@cnt_results, "untimely");
		@graph_data2 = get_data_grouped_by_year(@pct_results, "percent_untimely")
		render :layout => "results"
	end

	def dispute_rankings
		partition_cnt = "yes_cnt"
		partition_pct = "round(yes_cnt/(no_cnt+yes_cnt),2)"
		@cnt_results = ApplicationRecord.execQuery(dispute_query(partition_cnt));
		@pct_results = ApplicationRecord.execQuery(dispute_query(partition_pct));
		@graph_data1 = get_data_grouped_by_year(@cnt_results, "disputed")
		@graph_data2 = get_data_grouped_by_year(@pct_results, "percent_disputed")
		render :layout => "results"
	end

	def company_deep_dive
		@company_name = params[:company_name]
		query = "where name = '"

		# Add logic to escape apostrophe
		apostrophe_count = @company_name.count('\'')
		if apostrophe_count > 0
			name_fix = ""
			@company_name.split('').each {|c| 
				if c == '\''
					name_fix += '\'\''
				else
					name_fix += c
				end
			}
			query += name_fix
		else 
			query += params[:company_name]
		end
		
		query += "'"
		query = dive_query(query)
		@results = ApplicationRecord.execQuery(query)
		@datablocks = get_dive_data(@results)
		render :layout => "results"
	end

	def product_deep_dive
		@product_name = Products_Reverse[params[:product_name]]
		query = "where "
		query += params[:product_name]
		query = dive_query(query)
		@results = ApplicationRecord.execQuery(query)
		@datablocks = get_dive_data(@results)
		render :layout => "results"
	end

	#@results = ApplicationRecord.execQuery("select distinct name, type, submitted_via from camoen.complaint where rownum <= 50");

end
