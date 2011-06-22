require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "RandomWord" do
  it "defines the module" do 
    defined?(RandomWord).should be_true
  end
end
