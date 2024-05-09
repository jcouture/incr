require 'spec_helper'

describe Incr::Command::Laravel do
  let(:args) do
    ['major']
  end
  
  describe '#execute' do
    context 'with version specified in config/app.php' do
      before(:each) do
        @tmpdir = Dir.mktmpdir('incr', '.')
        Dir.mkdir(File.join(@tmpdir, "config"))
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

      let(:app_config_filename) { "#{File.dirname(__FILE__)}/../../fixtures/laravel/app.php" }

      it 'should increase the version number' do
        copy_files(File.join(@tmpdir, "config"), app_config_filename)

        expected = %(<?php

return [
	'name' => env('APP_NAME', 'Laravel'),
	'version' => '2.0.0',
]
)

        command = Incr::Command::Laravel.new(args, global_options)
        expect{ command.execute() }.to output("v2.0.0\n").to_stdout

        result = read_file(File.join(@tmpdir, 'config', 'app.php'))
        expect(result).to eql(expected)
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

      it 'should return an error' do
        command = Incr::Command::Laravel.new(args, global_options)
        expected = "'#{File.join('.', @tmpdir, 'config', 'app.php')}': file not found.\n"
        expect { command.execute() }.to output(expected).to_stderr
      end

      after(:each) do
        FileUtils.remove_entry_secure(@tmpdir)
      end
    end
  end
end
