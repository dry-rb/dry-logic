# frozen_string_literal: true

require 'benchmark/ips'
require 'hotch'
ENV['HOTCH_VIEWER'] ||= 'open'

require 'dry/logic'
require 'dry/logic/predicates'

def profile(&block)
  Hotch(filter: 'Dry', &block)
end

