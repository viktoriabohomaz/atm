# frozen_string_literal: true

RSpec.shared_examples 'success withdraw' do
  it 'gets correct result' do
    expect(subject.withdraw_cash).to eq(expected_result)
  end
end

RSpec.shared_examples 'failed operation' do
  it 'gets error' do
    expect { subject.withdraw_cash }.to raise_error(error)
  end
end

RSpec.describe Atm::EvilAtm do # rubocop:disable Metrics/BlockLength
  subject(:atm) { described_class.new }

  before do
    stub_const('Atm::Banalce::DEFAULT_BALANCE_FILE', './test_cach.json')
    allow(File).to receive(:read).and_return(data)
    allow(File).to receive(:open).and_return(nil)
    allow(Input).to receive(:call).and_return(input)
  end

  describe 'successed #withdraw' do
    context '#withdraw cash case 1'  do
      let(:input) { 200 }
      let(:expected_result) { { 50 => 4 } }
      let(:data) { { "50": 5, "100": 1 }.to_json }

      include_examples 'success withdraw'
    end

    context 'cash case 2' do
      let(:input) { 75 }
      let(:expected_result) { { 50 => 1, 20 => 1, 5 => 1 } }
      let(:data) { { "50": 2, "100": 2, "20": 1, "5": 1 }.to_json }

      include_examples 'success withdraw'
    end

    context '#withdraw cash case 3' do
      let(:input) { 75 }
      let(:expected_result) { { 5 => 15 } }
      let(:data) { { "50": 40, "100": 7, "20": 40, "5": 200 }.to_json }

      include_examples 'success withdraw'
    end
  end

  describe 'failed #withdraw' do
    context 'too low amount'  do
      let(:input) { 40 }
      let(:error) { Atm::AmountTooLow }
      let(:data) { { "50": 10, "100": 7, "20": 0, "5": 0 }.to_json }

      include_examples 'failed operation'
    end

    context 'too large amount' do
      let(:input) { 3000 }
      let(:error) { Atm::AmountTooHigh }
      let(:data) { { "50": 1, "100": 1, "20": 0, "5": 2 }.to_json }

      include_examples 'failed operation'
    end

    context 'negative input' do
      let(:input) { -100 }
      let(:error) { Atm::AmountInvalid }
      let(:data) { { "50": 10, "100": 7, "20": 40, "5": 200 }.to_json }

      include_examples 'failed operation'
    end

    context 'invalid input' do
      let(:input) { 123 }
      let(:error) { Atm::AmountInvalid }
      let(:data) { { "50": 10, "100": 7, "20": 43, "5": 200 }.to_json }

      include_examples 'failed operation'
    end
  end
end
