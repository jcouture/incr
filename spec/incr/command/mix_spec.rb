require 'spec_helper'

describe Incr::Command::Mix do
  let(:args) do
    ['major']
  end

  describe '#execute' do
    context 'with a normal mix file' do
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

      let(:mix_filename) { "#{File.dirname(__FILE__)}/../../fixtures/mix/mix.exs" }
      it 'increments the version number' do
        copy_files(@tmpdir, mix_filename)

        expected = %+defmodule Foobar.MixProject do
  use Mix.Project

  @version "2.0.0"

  def project do
    [
      app: :foobar,
      version: @version,
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
+
        mix = Incr::Command::Mix.new(args, global_options)
        expect{ mix.execute() }.to output("v2.0.0\n").to_stdout

        result = read_file(File.join(@tmpdir, 'mix.exs'))
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

      it 'returns an error' do
        mix = Incr::Command::Mix.new(args, global_options)
        expected = "'#{File.join('.', @tmpdir, 'mix.exs')}': file not found.\n"
        expect { mix.execute() }.to output(expected).to_stderr
      end

      after(:each) do
        FileUtils.remove_entry_secure(@tmpdir)
      end
    end
  end
end
