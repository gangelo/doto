# frozen_string_literal: true

require_relative '../../models/entry_group'
require_relative '../../services/entry_group/importer_service'
require_relative '../base_presenter_ex'
require_relative 'import_entry'
require_relative 'import_file'

module Doto
  module Presenters
    module Import
      class DatesPresenter < BasePresenterEx
        include ImportEntry
        include ImportFile

        attr_reader :from, :to, :import_file_path, :import_messages

        def initialize(from:, to:, import_file_path:, options: {})
          super(options: options)

          @from = from.beginning_of_day
          @to = to.end_of_day
          @import_file_path = import_file_path
        end

        def respond
          @import_messages = importer_service.call
        end

        def project_name
          @project_name ||= Models::Project.current_project.project_name
        end

        private

        def import_entry_groups
          @import_entry_groups ||= CSV.foreach(import_file_path,
            headers: true, header_converters: :symbol).with_object({}) do |entry_group_entry, entry_groups_hash|
            next unless import_entry?(entry_group_entry)

            entry_group_time = middle_of_day_for(entry_group_entry[:entry_group])
            next unless time_between_to_and_from_dates?(entry_group_time)

            project_name = entry_group_entry[:project_name]
            entry_groups_hash[project_name] = {} unless entry_groups_hash.key?(project_name)

            entry_group_time.to_date.to_s.tap do |time|
              entry_groups_hash[project_name][time] = [] unless entry_groups_hash[project_name].key?(time)
              entry_groups_hash[project_name][time] << entry_group_entry[:entry_group_entry]
            end
          end
        end

        def time_between_to_and_from_dates?(entry_group_time)
          entry_group_time.to_date.between?(from.to_date, to.to_date)
        end

        def middle_of_day_for(date_string)
          Time.parse(date_string).in_time_zone.middle_of_day
        end

        def importer_service
          @importer_service ||= Services::EntryGroup::ImporterService.new(
            import_projects: import_entry_groups, options: options
          )
        end
      end
    end
  end
end
