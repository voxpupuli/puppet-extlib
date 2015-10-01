require 'spec_helper'

describe 'try_set_value' do

    let(:data) do
      {
          'a' => {
              'b' => [
                  {'c' => '1'},
                  {'d' => '2'},
              ]
          },
      }
    end

    it 'should exist' do
      is_expected.not_to be_nil
    end

    context 'correct values, return true' do
      it 'should update a deep hash value' do
        is_expected.to run.with_params(data, 'a/x', 'd').and_return true
        expect(data['a']['x']).to eq 'd'
      end

      it 'should support array index in the path' do
        is_expected.to run.with_params(data, 'a/b/1/d', '3').and_return true
        expect(data['a']['b'][1]['d']).to eq '3'
      end

      it 'should be able to use a custom path separator' do
        is_expected.to run.with_params(data, 'a::b::0::c', '3', '::').and_return true
        expect(data['a']['b'][0]['c']).to eq '3'
      end
    end

    context 'bad values, return false' do
      it 'should do nothing for non-structure values' do
        data = 'test'
        is_expected.to run.with_params(data, 'a/b', 'c').and_return false
        expect(data).to eq 'test'
      end

      it 'should do nothing if path is not correct for a hash and value was not set' do
        is_expected.to run.with_params(data, 'a/x/1/d', '3').and_return false
      end

      it 'should raise error if path is not correct for an array and value was not set' do
        is_expected.to run.with_params(data, 'a/b/2/d', '3').and_return false
      end
    end

end
