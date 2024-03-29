require 'spec_helper'

SIMPLE_FILE_CONTENT = %(Hello, World!)

JSON_FILE_CONTENT = %({
  "name": "incr",
  "version": "7.0.0",
  "dependencies": {
    "is-number": "7.0.0"
  }
})

describe Incr::Service::FileHelper do
    describe '.replace' do
      context 'with a simple text file' do
        let(:filename) do
          create_tempfile(SIMPLE_FILE_CONTENT)
        end

        it 'should replace specified regular expression' do
          expected = "Buongiorno, World!"

          Incr::Service::FileHelper.replace(filename, /^Hel{2}o/, 'Buongiorno')
          result = read_file(filename)

          expect(result).to eql(expected)
        end
      end
      
      context 'with a JSON text file' do
        let(:filename) do
          create_tempfile(JSON_FILE_CONTENT)
        end
      end
      
      context 'with a JSON file' do
        let(:filename) do
          create_tempfile(JSON_FILE_CONTENT)
        end

        it 'should replace specified regular expression, once' do
          expected = %({
  "name": "incr",
  "version": "7.0.1",
  "dependencies": {
    "is-number": "7.0.0"
  }
})

          Incr::Service::FileHelper.replace(filename, /7.0.0/, '7.0.1')
          result = read_file(filename)

          expect(result).to eql(expected)
        end
      end

      context 'with a non-existent text' do
        let(:filename) do
          create_tempfile(SIMPLE_FILE_CONTENT)
        end

        it 'should not do anything' do
          expected = "Hello, World!"

          Incr::Service::FileHelper.replace(filename, /7.0.0/, '7.0.1')
          result = read_file(filename)

          expect(result).to eql(expected)
        end
      end
    end
end
