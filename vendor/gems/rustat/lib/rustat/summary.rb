module Rustat
  module Summary

    def self.number(array)
      array.size
    end

    def self.largest(array)
      array.max
    end

    def self.smallest(array)
      array.min
    end

    def self.sum(array)
      array.inject{|sum,x| sum + x }
    end

    def self.mean(array)
      sum(array) / array.length
    end

    def self.median(array)
      sorted = array.sort
      mid = array.size / 2
      if (sorted.size % 2) == 0
        (sorted[mid-1] + sorted[mid]).to_f / 2
      else
        sorted[mid]
      end
    end

    def self.mode(array)
      freq = array.inject(Hash.new) do |hash,value|
        hash[value] ||= 0
        hash[value] += 1
        hash
      end
      max_freq = freq.values.max
      modes = freq.keys.select{|x| freq[x] == max_freq}
      if modes.size == 1
        modes.first
      else
        modes.sort
      end
    end

    def self.standard_deviation(array)
      mean = mean(array)
      sum_squares = array.inject(0) {|sum,x| sum + (x.to_f - mean)**2}
      Math.sqrt(sum_squares/(array.size-1))
    end

    def self.summary(array)
      {
        :mean               => self.mean(array),
        :median             => self.median(array),
        :mode               => self.mode(array),
        :largest            => self.largest(array),
        :smallest           => self.smallest(array),
        :standard_deviation => self.standard_deviation(array),
        :number             => self.number(array)
      }
    end
 
    self.instance_eval do
      alias :sum_of_observations                :sum
      alias :mean_observation                   :mean
      alias :mode_observations                  :mode
      alias :median_observation                 :median
      alias :standard_deviation_of_observations :standard_deviation
      alias :summary_of_observations            :summary
      alias :number_of_observations             :number
      alias :smallest_observation               :smallest
      alias :largest_observation                :largest
    end

  end
end
