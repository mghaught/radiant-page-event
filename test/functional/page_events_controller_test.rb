require File.dirname(__FILE__) + '/../test_helper'

# Re-raise errors caught by the controller.
PageEventsController.class_eval { def rescue_action(e) raise e end }

class PageEventsControllerTest < Test::Unit::TestCase
  def setup
    @controller = PageEventsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

	def test_index_without_authentication
		get :index
		assert_response :redirect
	end
end
