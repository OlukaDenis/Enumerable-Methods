# frozen_string_literal: true
module Enumerable
  def my_each
    return to_enum unless block_given?

    i = 0
    while i < self.size
      yield self[i]
      i += 1
    end
    self
  end

  def my_each_with_index
    return to_enum unless  block_given?

    i = 0
    while i < self.size
      yield self[i], i 
      i += 1
    end
    self
  end

  def my_select
    return to_enum unless block_given?
    
    arr = []
    my_each { |param| arr << param if yield(param)}
    arr
  end

  def my_map
    return to_enum unless block_given?

    arr = []
    self.my_each { |param| arr << yield(param)}
    arr
  end

  def my_all?(arg = nil)
    if block_given?
      my_each { |element| return false unless yield(element) }
    elsif arg.nil?
      my_each { |element| return false unless element }
    elsif arg.class == Class
      my_each { |element| return false unless element.class.ancestors.include? arg }
    elsif arg.class == Regexp
      my_each { |element| return false unless element =~ arg }
    else
      my_each { |element| return false unless element == arg }
    end
    true
  end

  def my_any?(arg = nil)
    if block_given?
      my_each { |element| return true unless yield(element) }
    elsif arg.nil?
      my_each { |element| return true unless element }
    elsif arg.class == Class
      my_each { |element| return true unless element.class.ancestors.include? arg }
    elsif arg.class == Regexp
      my_each { |element| return true unless element =~ arg }
    else
      my_each { |element| return true unless element == arg }
    end
    true
  end

end
