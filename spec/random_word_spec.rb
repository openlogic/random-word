require File.expand_path("spec_helper", File.dirname(__FILE__))

describe RandomWord, "enumerator" do 
  subject {RandomWord.enumerator(["aaa", "bbb", "ccc"])}

  it "can get you the next word in it's list" do 
    subject.next.should be_one_of(["aaa", "bbb", "ccc"])
  end

  it "raises error when it runs out of words" do 
    3.times{subject.next}

    lambda{subject.next}.should raise_error(StopIteration)
  end

  # This test might pass sometimes even if the code it wrong.  It if
  # ever fails it is a serious issue and this test should be run
  # multiple times before deciding the issue has been fixed. 
  it "should only return a word one time" do 
    already_received = []
    3.times do
      (new_word = subject.next).should_not be_one_of(already_received)
      already_received << new_word
    end
  end
end

describe RandomWord do 
  it "can return a random noun enumerator" do 
    RandomWord.nouns.should respond_to(:next)
  end

  it "can return a random adj enumerator" do 
    RandomWord.adjs.should respond_to(:next)
  end

end
