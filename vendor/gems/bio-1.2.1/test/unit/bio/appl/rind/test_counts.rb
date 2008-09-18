require 'pathname'
libpath = Pathname.new(File.join(File.join(File.dirname(__FILE__), ['..'] * 5, 'lib'))).cleanpath.to_s
$:.unshift(libpath) unless $:.include?(libpath)


require 'test/unit'
require 'bio/appl/rind/counts'

class TestRindCounts < Test::Unit::TestCase

  bioruby_root  = Pathname.new(File.join(File.dirname(__FILE__), ['..'] * 5)).cleanpath.to_s
  TEST_DATA = Pathname.new(File.join(bioruby_root, 'test', 'data', 'rind')).cleanpath.to_s

  def setup
    str = File.read(File.join(TEST_DATA, 'counts.txt'))
    @counts = Bio::Rind::Counts.new(str)
  end

  def test_counts_parsed
    assert_not_nil(@counts)
  end
 
  def test_counts_size
    assert_equal(202,@counts.size)
  end

  def test_counts_first_position
    assert_not_nil(@counts[0])
    assert_equal(1,@counts[0].size)
    assert_not_nil(@counts[0]['M'])
    assert_equal(1.0,@counts[0]['M'].first)
    assert_equal(0.0,@counts[0]['M'].last)
  end

  def test_counts_tenth_position
    assert_not_nil(@counts[9])
    assert_equal(1,@counts[9].size)
    assert_not_nil(@counts[9]['T'])
    assert_equal(1.0,@counts[9]['T'].first)
    assert_equal(0.0,@counts[9]['T'].last)
  end

  def test_counts_hundredth_position
    assert_not_nil(@counts[99])
    assert_equal(2,@counts[99].size)
    assert_not_nil(@counts[99]['S'])
    assert_not_nil(@counts[99]['L'])
    assert_equal(1.0,@counts[99]['S'].first)
    assert_equal(0.0,@counts[99]['S'].last)
    assert_equal(2.813,@counts[99]['L'].first)
    assert_equal(0.681,@counts[99]['L'].last)
  end

end
