#!/bin/ruby
# frozen_string_literal: true

# Generic class to define rules
class Rules
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
