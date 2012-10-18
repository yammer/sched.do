require "spec_helper"

describe "app/views/shared/_yammer_javascript.html.erb" do

  context "when the user is logged in" do
    it "renders the network_id meta tag" do
      user = build_stubbed(:user)
      view.stubs(current_user: user)
      view.stubs(signed_in?: true)
      render :partial => "shared/yammer_javascript"

      rendered.should include('<meta property="yammer-network" content="1">')
    end
    context "when the user is not logged in" do
      it "it does not render the network_id meta tag" do
        user = build_stubbed(:user)
        view.stubs(current_user: user)
        view.stubs(signed_in?: false)
        render :partial => "shared/yammer_javascript"

        rendered.should_not include('<meta property="yammer-network" content="1">')
      end
    end
  end
end
