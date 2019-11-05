# frozen_string_literal: true

# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/PerceivedComplexity
# rubocop:disable Metrics/ModuleLength
# convention:Style/Documentation
# rubocop disable Metrics/MethodLength
module Enumerable
  def my_each
    return to_enum unless block_given?

    i = 0
    while i < size
      yield self[i]
      i += 1
    end
    self
  end

  def my_each_with_index
    return to_enum unless block_given?

    i = 0
    while i < size
      yield self[i], i
      i += 1
    end
    self
  end

  def my_select
    return to_enum unless block_given?

    arr = []
    my_each { |param| arr << param if yield(param) }
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
      my_each { |element| return true if yield(element) }
    elsif arg.class == Class
      my_each { |element| return true if element.class == arg }
    elsif arg.class == Regexp
      my_each { |element| return true if element =~ arg }
    elsif arg.nil?
      my_each { |element| return true if element }
    else
      my_each { |element| return true if element == arg }
    end
    false
  end

  def my_none?(arg = nil)
    if block_given?
      my_each { |element| return false if yield(element) }
    elsif arg.nil?
      my_each { |element| return false if element }
    elsif arg.class == Class
      my_each { |element| return false if element.class.ancestors.include? arg }
    elsif arg.class == Regexp
      my_each { |element| return false if element =~ arg }
    else
      my_each { |element| return false if element == arg }
    end
    true
  end

  def my_count(args = nil)
    counter = 0
    if block_given?
      my_each { |x| counter += 1 if yield(x) == true }
    elsif args.nil?
      my_each { counter += 1 }
    else
      my_each { |x| counter += 1 if x == args }
    end
    counter
  end

  def my_map(&proc)
    return to_enum unless block_given?

    arr = []
    my_each { |param| arr << (block_given? ? yield(param) : proc.call(param)) }
    arr
  end

  def my_inject(*args)
    arr = to_a.dup
    if args[0].nil?
      result = arr.shift
    elsif args[1].nil? && !block_given?
      symbol = args[0]
      result = arr.shift
    elsif args[1].nil? && block_given?
      result = args[0]
    else
      result = args[0]
      symbol = args[1]
    end
    arr[0..-1].my_each do |elem|
      result = if symbol
                 result.send(symbol, elem)
               else
                 yield(result, elem)
               end
    end
    result
  end
end

# rubocop enable Metrics/MethodLength

# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/PerceivedComplexity
# rubocop:enable Metrics/ModuleLength

def multiply_els(arr)
  arr.my_inject :*
end
