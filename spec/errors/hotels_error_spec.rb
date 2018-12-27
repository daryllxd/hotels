RSpec.describe HotelsError do
  it 'is a StandardError' do
    expect(described_class.new).to be_a_kind_of(StandardError)
  end
end
