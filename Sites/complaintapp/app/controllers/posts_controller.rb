class PostsController < ApplicationController
	def index
	end
	
	def query_directory
	end

	def query1
		p = ActiveRecord::Base.establish_connection
		c = p.connection

		# @results = c.execute("select * from camoen.complaint where rownum <= 10")
		# while r = @results.fetch()
		# 	puts r.join(',')
		# end
		# @results.close

		@results = c.exec_query("select distinct name from camoen.complaint where rownum <= 10").to_a
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

end
