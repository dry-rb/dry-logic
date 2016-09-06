require 'dry/logic/predicates'

RSpec.describe Predicates do
  it 'can be included in another module' do
    mod = Module.new { include Predicates }

    expect(mod[:key?]).to be_a(Method)
  end

  describe '.predicate' do
    it 'defines a predicate method' do
      mod = Module.new {
        include Predicates

        predicate(:test?) do |foo|
          true
        end
      }

      expect(mod.test?('arg')).to be(true)
    end
  end
end
