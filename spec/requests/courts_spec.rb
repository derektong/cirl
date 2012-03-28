require 'spec_helper'

describe "Court pages" do

  subject { page } 

  describe "manage court page" do
    before { visit courts_path } 

    it { should have_selector('title', text: full_title('Manage Courts') ) }
  end

end
