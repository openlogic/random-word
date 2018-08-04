require File.expand_path("spec_helper", File.dirname(__FILE__))

describe RandomWord, "enumerator" do 
  subject {RandomWord.enumerator(["aaa", "bbb", "ccc"])}

  it "can get you the next word in its list" do
    expect(subject.next).to be_one_of(["aaa", "bbb", "ccc"])
  end

  it "raises error when it runs out of words" do 
    3.times{subject.next}

    expect{subject.next}.to raise_error(StopIteration)
  end

  it "make sure each word is only returned once" do
    already_received = []
    3.times do
      expect(new_word = subject.next).not_to be_one_of(already_received)
      already_received << new_word
    end
  end
end

describe RandomWord do 
  after(:all) do
    RandomWord.instance_eval{ @nouns, @adjs = nil, nil } # reset rspec effects
  end

  it "can return a random noun enumerator" do 
    expect(RandomWord.nouns).to respond_to(:next)
  end

  it "can return a random adj enumerator" do 
    expect(RandomWord.adjs).to respond_to(:next)
  end

  it "can return a random phrase enumerator" do 
    expect(RandomWord.phrases.next).to be_a(String)
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

      expect(Set.new(received_words)).to eq(rec[:expected])
    end
  end

end

describe "RandomWord#nouns", "with exclusions" do

  subject{ RandomWord.nouns }

  before(:each) do
    expect(RandomWord).to receive(:load_word_list).and_return(["aaa","bbb", "ccc"])
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

    expect(received_words).not_to include "ccc"
    expect(received_words).to include "aaa"
    expect(received_words).to include "bbb"
  end

end

shared_examples 'allows constraints on word length' do |method|
  context 'when constraining' do
    let(:word_list) { %w(aa bbb cccc ddddd) }

    before(:each) do
      expect(RandomWord).to receive(:load_word_list).and_return(word_list)
    end

    after(:each) do
      RandomWord.instance_eval{ @nouns, @adjs = nil, nil }
    end

    let(:next_words) do
      [].tap do |next_words|
        loop do
          begin
            next_words << RandomWord.send(method, length_constraints).next
          rescue StopIteration
            # We've tried all the words in the short test list we're using.
            break
          end
        end
      end
    end

    context 'by maximum length' do
      let(:length_constraints) { {not_longer_than: 2} }

      it 'excludes the correct words' do
        expect(next_words).to match_array %w(aa)
      end
    end

    context 'by minimum length' do
      let(:length_constraints) { {not_shorter_than: 4} }

      it 'excludes the correct words' do
        expect(next_words).to match_array %w(cccc ddddd)
      end

    end

    context 'by both minimum and maximum length' do
      let(:length_constraints) { {not_shorter_than: 3, not_longer_than: 4} }

      it 'excludes the correct words' do
        expect(next_words).to match_array %w(bbb cccc)
      end
    end

    context 'by a perverse minimum length' do
      let(:length_constraints) { {not_shorter_than: -1234} }

      it 'includes all words' do
        expect(next_words).to match_array word_list
      end
    end

    context 'by a perverse maximum length' do
      let(:length_constraints) { {not_longer_than: -34234} }

      it 'excludes all words' do
        expect(next_words).to be_empty
      end
    end

    context 'and all words are within the constraints' do
      let(:length_constraints) { {not_shorter_than: 2, not_longer_than: 5} }

      it 'includes all words' do
        expect(next_words).to match_array word_list
      end
    end
  end
end

shared_examples 'changing constraints in subsequent calls' do |method|
  context 'when changing constraints in subsequent calls' do
    let(:word_list) { %w(defenestrate as can jubilant orangutan hat) }

    before(:each) do
      expect(RandomWord).to receive(:load_word_list).and_return(word_list)
    end

    after(:each) do
      RandomWord.instance_eval{ @nouns, @adjs = nil, nil }
    end

    it 'applies the new constraints' do
      short_words = %w(as can hat)
      long_words = %w(defenestrate jubilant orangutan)
      3.times { expect(short_words).to include RandomWord.send(method, not_longer_than: 3).next }
      3.times { expect(long_words).to include RandomWord.send(method, not_longer_than: 150).next }
      expect { RandomWord.send(method).next }.to raise_exception StopIteration
    end
  end
end

shared_examples 'with a seed specified' do |method|
  context 'when setting seed' do
    let(:word_list) { %w(defenestrate as can jubilant orangutan hat) }

    before(:each) do
      expect(RandomWord).to receive(:load_word_list).and_return(word_list)
    end

    after(:each) do
      RandomWord.instance_eval{ @nouns, @adjs = nil, nil }
    end

    it 'applies the new constraints' do
      RandomWord.rng = Random.new 1234

      short_words = %w(as can hat)
      long_words = %w(defenestrate jubilant orangutan)
      3.times { expect(short_words).to include RandomWord.send(method, not_longer_than: 3).next }
      3.times { expect(long_words).to include RandomWord.send(method, not_longer_than: 150).next }
      expect { RandomWord.send(method).next }.to raise_exception StopIteration
    end
  end
end

describe RandomWord do
  context '#nouns' do
    include_examples 'allows constraints on word length', :nouns
    include_examples 'changing constraints in subsequent calls', :nouns
    include_examples 'with a seed specified', :nouns
  end

  context '#adjs' do
    include_examples 'allows constraints on word length', :adjs
    include_examples 'changing constraints in subsequent calls', :adjs
    include_examples 'with a seed specified', :adjs
  end
end
