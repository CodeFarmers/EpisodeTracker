require "spec_helper"

describe ApplicationHelper do
  describe "#flash_class" do

    it "returns correct styles for notice" do
      flash_class(:notice).should == "alert alert-info"
    end

    it "returns correct styles for success" do
      flash_class(:success).should == "alert alert-success"
    end

    it "returns correct styles for error" do
      flash_class(:error).should == "alert alert-danger"
    end

    it "returns correct styles for alert" do
      flash_class(:alert).should == "alert alert-warning"
    end
  end
end