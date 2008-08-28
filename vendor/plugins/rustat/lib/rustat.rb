module Rustat
  def self.biggest_observation(array)
    array.max
  end

  def self.smallest_observation(array)
    array.min
  end

  def self.sum_of_observations(array)
   array.inject{|sum,x| sum + x }
  end

  def self.mean_observation(array)
    sum = self.sum_of_observations(array).to_f
    sum / array.length
  end

  def self.median_observation(array)
    sorted = array.sort
    mid = array.size / 2
    if (sorted.size % 2) == 0
      (sorted[mid-1] + sorted[mid]).to_f / 2
    else
      sorted[mid]
    end
  end

  def self.mode_observations(array)
    freq = array.inject(Hash.new) do |hash,value|
      hash[value] ||= 0
      hash[value] += 1
      hash
    end
    max_freq = freq.values.max
    freq.keys.select{|x| freq[x] == max_freq}
  end

  def self.standard_deviation_of_observations(array)
    mean = self.mean_observation(array)
    sum_squares = array.inject(0) {|sum,x| sum + (x.to_f - mean)**2}
    Math.sqrt(sum_squares/(array.size-1))
  end
end
