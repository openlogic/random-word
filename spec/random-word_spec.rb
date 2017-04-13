require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "RandomWord" do
  it "defines the module" do 
    expect(defined?(RandomWord)).to be_truthy
  end
end
