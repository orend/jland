require 'spec_helper'
require 'json'

describe "PositionsApis" do

  before do
    @user = Factory(:user)
    @position1 = Factory(:position, :name => 'pname1', :source => 'http://bla1', :user => @user)
    @position2 = Factory(:position, :name => 'pname2', :source => 'http://bla2', :user => @user)
  end

  describe "GET /users/:user_id/positions.json" do
    it "gets all positions for a user when there's one position" do
      position = Factory(:position, :name => 'pname', :source => 'http://bla')
      get "/users/#{position.user_id}/positions.json"

      res = ActiveSupport::JSON.decode(response.body)
      res.first['name'].should == position.name
      res.first['source'].should == position.source
      res.first['user_id'].should == position.user.id
      res.size.should == 1
      response.status.should be(200)
    end

    it "gets all positions for a user when there are two positions" do

      @position1.user.id.should == @position2.user.id
      get "/users/#{@user.id}/positions.json"

      res = ActiveSupport::JSON.decode(response.body).sort{|a,b| a.to_s <=> b.to_s}
      res[0]['name'].should == @position1.name
      res[0]['source'].should == @position1.source
      res[0]['user_id'].should == @position1.user.id
      res[1]['name'].should == @position2.name
      res[1]['source'].should == @position2.source
      res[1]['user_id'].should == @position2.user.id
      res.size.should == 2
      response.status.should be(200)
    end

    it "gets no positions for a user when there are no positions" do
      user = Factory(:user)
      get "/users/#{user.id}/positions.json"

      res = ActiveSupport::JSON.decode(response.body).sort{|a,b| a.to_s <=> b.to_s}
      res.should be_empty
      response.status.should be(200)
    end
  end

  describe "POST /users/:user_id/positions.json" do
    # TODO test that we get the minimal set of required fields
    it "creates a position" do
      post "/users/#{@user.id}/positions.json", :position => {:name => 'position_name'}

      res = ActiveSupport::JSON.decode(response.body)
      res['name'].should == 'position_name'
      res['user_id'].should == @user.id
      response.status.should be(201)
    end
  end

  describe "GET /users/:user_id/positions/:position_id.json" do
    it "gets a position for a user" do
      get "/users/#{@user.id}/positions/#{@position1.id}.json"

      res = ActiveSupport::JSON.decode(response.body)
      res['name'].should == 'pname1'
      res['user_id'].should == @user.id
      response.status.should be(200)
    end

    it "doesn't get a position for a non-existing position" do
      Position.exists?(888888).should be_false
      get "/users/#{@user.id}/positions/888888.json"

      response.status.should be(404)
    end
  end

  describe "DELETE /users/:user_id/positions/:position_id.json" do
    it "deletes a position" do
      Position.exists?(@position1.id).should be_true
      delete "/users/#{@user.id}/positions/#{@position1.id}.json"
      Position.exists?(@position1.id).should be_false

      response.body.should be_empty
      response.status.should be(204)

      @position1
    end
  end
end
