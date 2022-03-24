require 'spec_helper'

describe Incr::Command::Npm do
  let(:args) do
    ['major']
  end
  
  describe '#execute' do
    context 'with NPM v6 files' do
      before(:each) do
        @tmpdir = Dir.mktmpdir('incr', '.')
      end

      let(:global_options) do
        {
          commit: false,
          tag: false,
          noop: true,
          versionFileDirectory: @tmpdir,
          tagNamePattern: 'v%s'
        }
      end

      let(:npmv6_package_filename) { "#{File.dirname(__FILE__)}/../../fixtures/npmv6/package.json" }
      let(:npmv6_package_lock_filename) { "#{File.dirname(__FILE__)}/../../fixtures/npmv6/package-lock.json" }
  
      it 'should increase the version number' do
        copy_files(@tmpdir, npmv6_package_filename, npmv6_package_lock_filename)

        expected = %({
  "name": "foobar",
  "version": "8.0.0",
  "dependencies": {
    "is-number": "^7.0.0"
  }
}
)
        lockfile_expected = %({
  "name": "foobar",
  "version": "8.0.0",
  "lockfileVersion": 1,
  "requires": true,
  "dependencies": {
    "is-number": {
      "version": "7.0.0",
      "resolved": "https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz",
      "integrity": "sha512-41Cifkg6e8TylSpdtTpeLVMqvSBEVzTttHvERD741+pnZ8ANv0004MRL43QKPDlK9cGvNp6NZWZUBlbGXYxxng=="
    }
  }
}
)
        npm = Incr::Command::Npm.new(args, global_options)
        npm.execute()

        result = read_file(File.join(@tmpdir, 'package.json'))
        expect(result).to eql(expected)

        lockfile_result = read_file(File.join(@tmpdir, 'package-lock.json'))
        expect(lockfile_expected).to eql(lockfile_result)
      end

      after(:each) do
        FileUtils.remove_entry_secure(@tmpdir)
      end
    end

    context 'with NPM v7 files' do
      before(:each) do
        @tmpdir = Dir.mktmpdir('incr', '.')
      end

      let(:global_options) do
        {
          commit: false,
          tag: false,
          noop: true,
          versionFileDirectory: @tmpdir,
          tagNamePattern: 'v%s'
        }
      end

      let(:npmv7_package_filename) { "#{File.dirname(__FILE__)}/../../fixtures/npmv7/package.json" }
      let(:npmv7_package_lock_filename) { "#{File.dirname(__FILE__)}/../../fixtures/npmv7/package-lock.json" }

      it 'should increase the version number' do
        copy_files(@tmpdir, npmv7_package_filename, npmv7_package_lock_filename)

        expected = %({
  "name": "foobar",
  "version": "8.0.0",
  "dependencies": {
    "is-number": "^7.0.0"
  }
}
)
        lockfile_expected = %({
  "name": "foobar",
  "version": "8.0.0",
  "lockfileVersion": 2,
  "requires": true,
  "packages": {
    "": {
      "name": "foobar",
      "version": "8.0.0",
      "dependencies": {
        "is-number": "^7.0.0"
      }
    },
    "node_modules/is-number": {
      "version": "7.0.0",
      "resolved": "https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz",
      "integrity": "sha512-41Cifkg6e8TylSpdtTpeLVMqvSBEVzTttHvERD741+pnZ8ANv0004MRL43QKPDlK9cGvNp6NZWZUBlbGXYxxng==",
      "engines": {
        "node": ">=0.12.0"
      }
    }
  },
  "dependencies": {
    "is-number": {
      "version": "7.0.0",
      "resolved": "https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz",
      "integrity": "sha512-41Cifkg6e8TylSpdtTpeLVMqvSBEVzTttHvERD741+pnZ8ANv0004MRL43QKPDlK9cGvNp6NZWZUBlbGXYxxng=="
    }
  }
}
)
        npm = Incr::Command::Npm.new(args, global_options)
        npm.execute()

        result = read_file(File.join(@tmpdir, 'package.json'))
        expect(result).to eql(expected)

        lockfile_result = read_file(File.join(@tmpdir, 'package-lock.json'))
        expect(lockfile_expected).to eql(lockfile_result)
      end

      after(:each) do
        FileUtils.remove_entry_secure(@tmpdir)
      end
    end
  end
end
