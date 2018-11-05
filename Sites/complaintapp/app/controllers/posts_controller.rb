class PostsController < ApplicationController
	def index
		p = ActiveRecord::Base.establish_connection
		c = p.connection
		@results = c.execute("select * from camoen.complaint where rownum <= 10")
		while r = @results.fetch()
			puts r.join(',')
		end
		@results.close
	end
	

end
