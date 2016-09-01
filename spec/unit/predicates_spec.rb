require 'dry/logic/predicates'

RSpec.describe Predicates do
  it 'can be included in another module' do
    mod = Module.new { include Predicates }

    expect(mod[:key?]).to be_a(Method)
  end
end
