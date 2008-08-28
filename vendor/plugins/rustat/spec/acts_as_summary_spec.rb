require File.expand_path(File.join(File.dirname(__FILE__), '../../../../config/environment.rb'))

require 'rustat/acts_as_summary'

describe Rustat::ActsAsSummary do

  after do
    Person.delete_all
  end

  describe 'standard inclusion into class' do
    it 'should respond to the expected method names' do
      Person.acts_as_summary :age
 
      Person.should respond_to(:mean_age)
      Person.should respond_to(:median_age)
      Person.should respond_to(:mode_ages)
      Person.should respond_to(:smallest_age)
      Person.should respond_to(:biggest_age)
      Person.should respond_to(:standard_deviation_of_ages)
    end
  end

  describe 'summarising some simple data' do

    before do
      Person.acts_as_summary :age
      [1,2,3,4,5].each { |x| Person.create(:age => x)}
    end

    it 'should return the expected smallest value' do
      Person.smallest_age.should == 1
    end

    it 'should return the expected biggest value' do
      Person.biggest_age.should == 5
    end

    it 'should return the expected mean value' do
      Person.mean_age.should == 3
    end

    it 'should return the expected median value' do
      Person.median_age.should == 3
    end

    it 'should return the expected mode values' do
      Person.mode_ages.sort.should == [1,2,3,4,5].sort
    end

    it 'should return the expected standard deviation value' do
      Person.standard_deviation_of_ages.should be_close(1.581139, 0.001)
    end
  end

  describe 'summarising some transformed data with a different name' do

    before do
      Person.acts_as_summary :age, :name => :doubled_age,
        :map => lambda {|age| age * 2 }

      [1,2,3,4,5].each { |x| Person.create(:age => x)}
    end

    it 'should respond to the expected methods' do
      Person.should respond_to(:mean_doubled_age)
      Person.should respond_to(:median_doubled_age)
      Person.should respond_to(:mode_doubled_ages)
      Person.should respond_to(:smallest_doubled_age)
      Person.should respond_to(:biggest_doubled_age)
      Person.should respond_to(:standard_deviation_of_doubled_ages)
    end

    it 'should return the expected smallest value' do
      Person.smallest_doubled_age.should == 2
    end

    it 'should return the expected biggest value' do
      Person.biggest_doubled_age.should == 10
    end

    it 'should return the expected mean value' do
      Person.mean_doubled_age.should == 6
    end

    it 'should return the expected median value' do
      Person.median_doubled_age.should == 6
    end

    it 'should return the expected mode values' do
      Person.mode_doubled_ages.sort.should == [2,4,6,8,10].sort
    end

    it 'should return the expected standard deviation value' do
      Person.standard_deviation_of_doubled_ages.should be_close(3.162278, 0.001)
    end

  end

  describe 'summarising some data with a map and a select' do

    before do
      Person.acts_as_summary :age, :name => :even_square_age,
        :map    => lambda {|age| age ** 2 },
        :select => lambda {|person| person.age % 2 == 0 }

      [1,2,3,4,5].each { |x| Person.create(:age => x)}
    end

    it 'should respond to the expected methods' do
      Person.should respond_to(:mean_even_square_age)
      Person.should respond_to(:median_even_square_age)
      Person.should respond_to(:mode_even_square_ages)
      Person.should respond_to(:smallest_even_square_age)
      Person.should respond_to(:biggest_even_square_age)
      Person.should respond_to(:standard_deviation_of_even_square_ages)
    end

    it 'should return the expected smallest value' do
      Person.smallest_even_square_age.should == 4
    end

    it 'should return the expected biggest value' do
      Person.biggest_even_square_age.should == 16
    end

    it 'should return the expected mean value' do
      Person.mean_even_square_age.should == 10
    end

    it 'should return the expected median value' do
      Person.median_even_square_age.should == 10
    end

    it 'should return the expected mode values' do
      Person.mode_even_square_ages.sort.should == [4,16].sort
    end

    it 'should return the expected standard deviation value' do
      Person.standard_deviation_of_even_square_ages.should be_close(8.485281, 0.001)
    end

  end

end
