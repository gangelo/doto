# frozen_string_literal: true

RSpec.describe Doto::Migration::V20240210161248::Service, type: :migration do
  subject(:service) { described_class.new(options: options) }

  before do
    create(:migration_version, version: migration_version, options: options)
  end

  let(:options) { {} }
  let(:migration_version) { 20230613121411 } # rubocop:disable Style/NumericLiterals

  describe '#initialize' do
    let(:migration_version) { 0 }

    it_behaves_like 'no error is raised'
  end

  describe '#migrate_if!' do
    subject(:service_migrate_if) { service.migrate_if! }

    context 'when the migration version is not 20230613121411' do
      before do
        mock_migration_version_for(version: migration_version)
        service_migrate_if
      end

      let(:migration_version) { 0 }
      let(:expected) { File.join('spec', 'fixtures', 'folders', migration_version.to_s) }
      let(:actual) { Doto::Support::Fileable.doto_folder }

      it 'does not make any changes to the doto folder structure or configuration file' do
        expect(doto_folders_and_file_contents_match?(expected: expected, actual: actual)).to be(true)
      end
    end

    context 'when the migration version is 20230613121411' do
      before do
        mock_migration_version_for(version: migration_version)
        service_migrate_if
      end

      shared_examples 'the migration was run in pretend mode' do
        let(:expected) { File.join('spec', 'fixtures', 'folders', migration_version.to_s) }
        let(:actual) { Doto::Support::Fileable.doto_folder }

        it 'does not make any changes to the doto folder structure or configuration file' do
          expect(doto_folders_and_file_contents_match?(expected: expected, actual: actual)).to be(true)
        end
      end

      context 'when the pretend option is implicitly set to true (not provided)' do
        it_behaves_like 'the migration was run in pretend mode'
      end

      context 'when the pretend option is explicitly set to true' do
        let(:options) { { pretend: true } }

        it_behaves_like 'the migration was run in pretend mode'
      end

      context 'when the pretend option is set to false' do
        let(:options) { { pretend: false } }
        let(:expected) { File.join('spec', 'fixtures', 'folders', 20240210161248.to_s) } # rubocop:disable Style/NumericLiterals
        let(:actual) { Doto::Support::Fileable.doto_folder }

        it 'migrates the doto folder structure and configuration file' do
          expect(doto_folders_and_file_contents_match?(expected: expected, actual: actual)).to be(true)
        end
      end
    end
  end
end
