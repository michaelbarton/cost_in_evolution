require File.expand_path(File.join(File.dirname(__FILE__), '../../../../config/environment.rb'))

require 'rustat/acts_as_summary'

def expected_results(model,name,expects)
  it 'should return the expected smallest value' do
    model.should respond_to("smallest_#{name}")
    model.send("smallest_#{name}").should == expects[:smallest]
  end

  it 'should return the expected largest value' do
    model.should respond_to("biggest_#{name}")
    model.send("biggest_#{name}").should == expects[:biggest]
  end

  it 'should return the expected mean value' do
    model.should respond_to("mean_#{name}")
    model.send("mean_#{name}").should == expects[:mean]
  end

  it 'should return the expected median value' do
    model.should respond_to("median_#{name}")
    model.send("median_#{name}").should == expects[:median]
  end

  it 'should return the expected mode values' do
    model.should respond_to("mode_#{name}s")
    model.send("mode_#{name}s").sort.should == expects[:mode].sort
  end

  it 'should return the expected standard deviation value' do
    model.should respond_to("standard_deviation_of_#{name}s")
    model.send("standard_deviation_of_#{name}s").should be_close(expects[:sd],0.001)
  end

  it 'should return the expected number of observations' do
    model.should respond_to("number_of_#{name}s")
    model.send("number_of_#{name}s").should == expects[:number]
  end

  it 'should return the expected summary' do
    model.should respond_to("summary_of_#{name}s")
    summary = model.send("summary_of_#{name}s")
    summary[:number].should == expects[:number]
    summary[:median].should == expects[:median]
    summary[:mean].should == expects[:mean]
    summary[:mode].sort.should == expects[:mode].sort
    summary[:smallest].should == expects[:smallest]
    summary[:number].should == expects[:number]
    summary[:standard_deviation].should be_close(expects[:sd],0.001)
  end
end

describe Rustat::ActsAsSummary do

  after do
    Person.delete_all
  end

  describe 'summarising some simple data' do

    before do
      Person.acts_as_summary :age
      [1,2,3,4,5].each { |x| Person.create(:age => x)}
    end

    expected_results(Person,:age,{
      :smallest => 1,
      :biggest  => 5,
      :mean     => 3,
      :median   => 3,
      :mode     => [1,2,3,4,5],
      :sd       => 1.581139,
      :number   => 5
    })

  end

  describe 'summarising some transformed data with a different name' do

    before do
      Person.acts_as_summary :age, :name => :doubled_age,
        :map => lambda {|age| age * 2 }

      [1,2,3,4,5].each { |x| Person.create(:age => x)}
    end

    expected_results(Person,:doubled_age,{
      :smallest => 2,
      :biggest  => 10,
      :mean     => 6,
      :median   => 6,
      :mode     => [2,4,6,8,10],
      :sd       => 3.162278,
      :number   => 5
    })

  end

  describe 'summarising some data with a map and a select' do

    before do
      Person.acts_as_summary :age, :name => :even_square_age,
        :map    => lambda {|age| age ** 2 },
        :select => lambda {|person| person.age % 2 == 0 }

      [1,2,3,4,5].each { |x| Person.create(:age => x)}
    end

    expected_results(Person,:even_square_age,{
      :smallest => 4,
      :biggest  => 16,
      :mean     => 10,
      :median   => 10,
      :mode     => [4,16],
      :sd       => 8.485281,
      :number   => 2
    })

  end

  describe 'summarising some data using an active record command' do

    before do
      Person.acts_as_summary :age, :active_record => {
        :conditions  => ["age > ?",5]
      }

      [1,2,3,4,5,6,7,8,9,10].each { |x| Person.create(:age => x)}
    end

    expected_results(Person,:age,{
      :smallest => 6,
      :biggest  => 10,
      :mean     => 8,
      :median   => 8,
      :mode     => [6,7,8,9,10],
      :sd       => 1.581139,
      :number   => 5
    })

  end

end
