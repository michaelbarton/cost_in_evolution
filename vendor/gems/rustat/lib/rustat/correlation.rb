module Rustat
  module Correlation

    def self.spearman(x,y)
      raise ArgumentError, "Argument lengths do not match" if x.size != y.size
      pearson(fractional_rank(x),fractional_rank(y))
    end

    # modified from http://blog.trevorberg.com/2008/08/13/standard-deviation-and-correlation-coefficient-in-ruby/
    def self.pearson(x,y)
      raise ArgumentError, "Argument lengths do not match" if x.size != y.size

      # Calculate the necessary values  
      n = x.size

      sum_x = Rustat::Summary.sum(x)
      sum_y = Rustat::Summary.sum(y)

      sum_x_squared = Rustat::Summary.sum(x.map{|i| i**2 })
      sum_y_squared = Rustat::Summary.sum(y.map{|i| i**2 })

      sum_xy = Rustat::Summary.sum((0...n).to_a.map{|i| x[i]*y[i]})

      # Calculate the correlation value  
      left = n * sum_xy - sum_x * sum_y
      right = ((n * sum_x_squared - sum_x**2) * (n * sum_y_squared - sum_y**2)) ** 0.5

      left / right
    end

    private

    def self.fractional_rank(x)
      binned = x.inject(Hash.new) do |hash,value|
        hash[value] ||= 0
        hash[value] += 1
        hash
      end

      rank = 1
      ranks = binned.keys.sort.inject(Hash.new) do |hash, key|
        if binned[key] == 1
          hash[key] = rank
        else
          n = binned[key]
          mid = Rustat::Summary.median(((rank+1)..(rank+n)).to_a) - 1
          hash[key] = mid
        end
        rank += binned[key]
        hash
      end

      x.map{|i| ranks[i]}
    end

  end
end
