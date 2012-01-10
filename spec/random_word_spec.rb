require File.expand_path("spec_helper", File.dirname(__FILE__))

describe RandomWord, "enumerator" do 
  subject {RandomWord.enumerator(["aaa", "bbb", "ccc"])}

  it "can get you the next word in its list" do
    subject.next.should be_one_of(["aaa", "bbb", "ccc"])
  end

  it "raises error when it runs out of words" do 
    3.times{subject.next}

    lambda{subject.next}.should raise_error(StopIteration)
  end

  it "make sure each word is only returned once" do 
    already_received = []
    3.times do
      (new_word = subject.next).should_not be_one_of(already_received)
      already_received << new_word
    end
  end
end

describe RandomWord do 
  after(:all) do
    RandomWord.instance_eval{ @nouns, @adjs = nil, nil } # reset rspec effects
  end

  it "can return a random noun enumerator" do 
    RandomWord.nouns.should respond_to(:next)
  end

  it "can return a random adj enumerator" do 
    RandomWord.adjs.should respond_to(:next)
  end

  it "can return a random phrase enumerator" do 
    RandomWord.phrases.next.should be_a(String)
  end
end

describe RandomWord, "#exclude" do
  let(:word_list) { ["aaa","ccc","c", "cab", "abc", "ace", "dad"] }

  [
    {:name => "normal words", :exclude => "ccc", :expected => Set.new(["aaa","c", "cab", "abc", "ace", "dad"])},
    {:name => "regex", :exclude => /c/, :expected => Set.new(["aaa", "dad"])},
    {:name => "list", :exclude => [/c/,/d/], :expected => Set.new(["aaa"])},
  ].each do |rec|
    it "will not return an excluded #{rec[:name]}" do
      subject = RandomWord.enumerator(word_list, rec[:exclude])

      received_words = []
      loop do
        received_words << subject.next
      end rescue StopIteration

      Set.new(received_words).should == rec[:expected]
    end
  end

end

describe "RandomWord#nouns", "with exclusions" do

  subject{ RandomWord.nouns }

  before(:each) do
    RandomWord.should_receive(:load_word_list).and_return(["aaa","bbb", "ccc"])
  end

  after(:each) do
    RandomWord.exclude_list.clear
    RandomWord.instance_eval{ @nouns, @adjs = nil, nil } # reset rspec effects
  end

  it "will not return an excluded word" do
    RandomWord.exclude_list << "ccc"

    received_words = []
    loop do
      received_words << subject.next
    end

    received_words.should_not include "ccc"
    received_words.should include "aaa"
    received_words.should include "bbb"
  end

end

