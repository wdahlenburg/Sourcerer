#!/bin/ruby
# frozen_string_literal: true

# Apply a condition across all rule sets
class Rules
  def initialize(rules_set, condition='or')
    @rules_set = rules_set
    @condition = condition
  end

  def evaluate(url)
    case @condition
    when 'and'
      @rules_set.all? { |r| r.evaluate(url) }
    when 'or'
      @rules_set.any? { |r| r.evaluate(url) }
    when 'not'
      !@rules_set.any? { |r| r.evaluate(url) }
    else
      raise StandardError, 'Supported conditions (and, or, not)'
    end
  end
end
