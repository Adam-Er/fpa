class ApplicationRecord < ActiveRecord::Base
	self.abstract_class = true
	def self.execQuery(q)
	 	p = ActiveRecord::Base.establish_connection
		c = p.connection
		c.exec_query(q).to_a
	end
end
