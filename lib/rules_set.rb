#!/bin/ruby
# frozen_string_literal: true

# A set of Rule objects, which can have a condition applied to them
class RulesSet
  def initialize(rules, condition = 'or')
    @rules = rules
    @condition = condition
  end

  def evaluate(url)
    case @condition
    when 'and'
      @rules.all? { |r| r.evaluate(url) }
    when 'or'
      @rules.any? { |r| r.evaluate(url) }
    else
      raise StandardError, 'Supported conditions (and, or)'
    end
  end
end
