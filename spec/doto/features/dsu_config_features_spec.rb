# frozen_string_literal: true

RSpec.describe 'Doto config features', type: :feature do
  subject(:cli) { Doto::CLI.start(args) }

  let(:args) { %w[config] }
  let(:with_config) do
    file_path = 'spec/fixtures/files/.doto'
    file_name = File.basename(file_path)
    destination_path = File.join(Doto::Support::Fileable.config_folder, file_name)
    FileUtils.cp(file_path, destination_path)
  end

  context "when 'doto help config' is called" do
    let(:args) { %w[help config] }

    it 'displays help' do
      expect { cli }.to output(/Commands:.*rspec config/m).to_stdout
    end
  end

  context "when 'doto config info' is called" do
    let(:args) { %w[config info] }
    let(:expected_output) do
      /.+Configuration file contents.+\)/m
    end

    it 'displays config info' do
      expect { cli }.to output(expected_output).to_stdout
    end
  end
end
