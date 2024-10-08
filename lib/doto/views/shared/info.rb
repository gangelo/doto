# frozen_string_literal: true

require_relative 'message'

module Doto
  module Views
    module Shared
      class Info < Message
        def initialize(messages:, header: nil, options: {})
          options = { header: header, output_stream: $stdout }.merge(options)

          super(messages: messages, message_type: :info, options: options)
        end
      end
    end
  end
end
