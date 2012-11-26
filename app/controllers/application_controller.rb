class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  before_filter :set_timezone
  #before_filter :prepare_mobile_request!
 


 
  # private
	 #  def mobile_request?
	 #  	request.user_agent =~ /Mobile|webOs/
	 #  end
	 #  helper_method :mobile_request?

	 # 	def prepare_mobile_request!
		#  	if mobile_request?
		#  		request.format = :mobile
		#  	end
		# end

end
