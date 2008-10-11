require File.expand_path(File.join(File.dirname(__FILE__),'..','helper.rb'))

describe Rustat::Correlation do

  describe 'ranking method' do

    x = [32,73,46,32,95,73,87,73,22,69,13,57]

    it 'should return the expected fractional rankings' do
      Rustat::Correlation.fractional_rank(x).should == [3.5,9,5,3.5,12,9,11,9,2,7,1,6]
    end

  end

  describe 'correlation between two simple data sets' do

    x = [106, 86, 100, 101, 99, 103, 97, 113, 112, 110]
    y = [7,   0,  27,  50,  28, 29,  20, 12,  6,   17]

    it 'should return the correct spearman rho' do
      Rustat::Correlation.spearman(x,y).should be_close(-0.175758,0.00001)
    end

    it 'should return the correct pearson rho' do
      Rustat::Correlation.pearson(x,y).should be_close(-0.03760147,0.00001)
    end
  end

  describe 'correlation between two random data sets' do

   x = [-0.6200129,0.6143180,0.5102048,-1.1960710,0.1534104,0.1331193,-1.3897394,0.6099581,1.3186249,-0.2751346]
   y = [-0.5964407,-1.7029324,-1.0979491,-1.8332710,-0.6338129,0.6567326,-1.7161549,-0.4631890,-0.4333308,0.3500636]

    it 'should return the correct spearman rho' do
      Rustat::Correlation.spearman(x,y).should be_close(0.3212121,0.00001)
    end

    it 'should return the correct pearson rho' do
      Rustat::Correlation.pearson(x,y).should be_close(0.3459828,0.00001)
    end
  end

  describe 'given incorrect data' do

    x = (1..5).to_a
    y = (1..4).to_a

    it 'should return the correct spearman rho' do
      lambda {
        Rustat::Correlation.spearman(x,y)
      }.should raise_error(ArgumentError)
    end

    it 'should return the correct pearson rho' do
      lambda {
        Rustat::Correlation.pearson(x,y)
      }.should raise_error(ArgumentError)
    end

  end

end
