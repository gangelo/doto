# frozen_string_literal: true

module Doto
  module Migration
    module RawHelpers
      module ConfigurationHash
        attr_accessor :default_project

        def to_h
          read.merge(version: version, default_project: default_project)
        end
      end
    end
  end
end
