require 'spec_helper'

describe HomeController do
  describe :routes do
    it { should route(:get, "/").to(:controller => :home, :action => :index) }
  end
end