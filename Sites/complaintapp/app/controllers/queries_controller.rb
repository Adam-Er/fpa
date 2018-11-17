class QueriesController < ApplicationController
	def index
		render :layout => "landing_page"
	end

	def dashboard
	end
	
	def query_directory
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

	def custom_search
	end

	def product_rankings
	end

	def timeliness_rankings
	end

	def dispute_rankings
	end


end
