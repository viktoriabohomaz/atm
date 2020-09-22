# frozen_string_literal: true

RSpec.describe Atm::EvilAtm do
  subject(:atm) { described_class.new(200) }

  it 'withdraw cash' do
    expect(subject.withdraw_cash).to eq(50 => 4)
  end
end
