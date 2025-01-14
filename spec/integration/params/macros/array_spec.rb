RSpec.describe 'Params / Macros / array' do
  context 'array of hashes' do
    subject(:schema) do
      Dry::Schema.Params do
        required(:songs).array(:hash) do
          required(:title).filled(:string)
        end
      end
    end

    it 'coerces an empty string to an array' do
      result = schema.("songs" => "")

      expect(result).to be_success
      expect(result.to_h).to eq(songs: [])
    end
  end

  context 'when inherited' do
    subject(:schema) do
      Dry::Schema.Params(parent: parent) do
        optional(:user).array(:hash)
      end
    end

    let(:parent) do
      Dry::Schema.Params do
        optional(:id).value(:integer)
      end
    end

    it 'applies coercion and rules' do
      result = schema.('id' => '1', 'user' => nil)

      expect(result.errors.to_h).to eql(user: ['must be an array'])
      expect(result.to_h).to eql(id: 1, user: nil)
    end
  end
end
