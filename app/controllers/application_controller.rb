class ApplicationController < ActionController::API
  before_action :fake_load
  
  # API通信を遅くする
  def fake_load
    sleep(1)
  end
end
