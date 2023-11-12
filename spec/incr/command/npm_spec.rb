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
          version_file_dir: @tmpdir,
          tag_name_pattern: 'v%s'
        }
      end

      let(:npmv6_package_filename) { "#{File.dirname(__FILE__)}/../../fixtures/npmv6/package.json" }
      let(:npmv6_package_lock_filename) { "#{File.dirname(__FILE__)}/../../fixtures/npmv6/package-lock.json" }
  
      it 'inrements the version number' do
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
        expect{ npm.execute() }.to output("v8.0.0\n").to_stdout

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
          version_file_dir: @tmpdir,
          tag_name_pattern: 'v%s'
        }
      end

      let(:npmv7_package_filename) { "#{File.dirname(__FILE__)}/../../fixtures/npmv7/package.json" }
      let(:npmv7_package_lock_filename) { "#{File.dirname(__FILE__)}/../../fixtures/npmv7/package-lock.json" }

      it 'increments the version number' do
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
        expect{ npm.execute() }.to output("v8.0.0\n").to_stdout

        result = read_file(File.join(@tmpdir, 'package.json'))
        expect(result).to eql(expected)

        lockfile_result = read_file(File.join(@tmpdir, 'package-lock.json'))
        expect(lockfile_expected).to eql(lockfile_result)
      end

      after(:each) do
        FileUtils.remove_entry_secure(@tmpdir)
      end
    end

    context 'without expected files' do
      before(:each) do
        @tmpdir = Dir.mktmpdir('incr', '.')
      end

      let(:global_options) do
        {
          commit: false,
          tag: false,
          noop: true,
          version_file_dir: @tmpdir,
          tag_name_pattern: 'v%s'
        }
      end

      it 'returns an error' do
        npm = Incr::Command::Npm.new(args, global_options)
        expected = "'#{File.join('.', @tmpdir, 'package.json')}': file not found.\n"
        expect { npm.execute() }.to output(expected).to_stderr
      end

      after(:each) do
        FileUtils.remove_entry_secure(@tmpdir)
      end
    end

    context 'without expected lock file' do
      before(:each) do
        @tmpdir = Dir.mktmpdir('incr', '.')
      end

      let(:global_options) do
        {
          commit: false,
          tag: false,
          noop: true,
          version_file_dir: @tmpdir,
          tag_name_pattern: 'v%s'
        }
      end

      let(:npmv6_package_filename) { "#{File.dirname(__FILE__)}/../../fixtures/npmv6/package.json" }

      it 'returns an error ' do
        copy_files(@tmpdir, npmv6_package_filename)
        npm = Incr::Command::Npm.new(args, global_options)
        expected = "'#{File.join('.', @tmpdir, 'package-lock.json')}': file not found.\n"
        expect { npm.execute() }.to output(expected).to_stderr
      end

      after(:each) do
        FileUtils.remove_entry_secure(@tmpdir)
      end
    end
  end
end
