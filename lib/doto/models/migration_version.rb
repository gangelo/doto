# frozen_string_literal: true

require_relative '../crud/json_file'
require_relative '../services/migration_version/hydrator_service'
require_relative '../validators/version_validator'

module Doto
  module Models
    # This class represents a doto migration_version.
    class MigrationVersion < Crud::JsonFile
      include Support::Fileable

      attr_reader :options

      alias exist? file_exist?

      def initialize(version: nil, options: {})
        super(migration_version_path)

        FileUtils.mkdir_p migration_version_folder

        @options = options || {}
        @version = version and return if version

        file_hash = if exist?
          read do |migration_version_hash|
            hydrated_hash =
              Services::MigrationVersion::HydratorService.new(migration_version_hash: migration_version_hash).call
            migration_version_hash.merge!(hydrated_hash)
          end
        end

        self.version = file_hash.try(:[], :version) || 0
      end

      # Returns true if the current doto install is the
      # current migration version.
      def current_migration?
        version == Doto::Migration::VERSION
      end

      def to_h
        {
          version: version
        }
      end
    end
  end
end
