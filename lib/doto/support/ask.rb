# frozen_string_literal: true

require 'io/console'
require 'thor'

module Doto
  module Support
    module Ask
      def ask_while(prompt, options: {}) # rubocop:disable Lint/UnusedMethodArgument
        loop do
          print prompt
          char = $stdin.getch
          puts char
          return char if yield(char)

          char
        end
      end

      def yes?(prompt, options: {})
        auto_prompt = auto_prompt(prompt, options)

        unless auto_prompt.nil?
          puts prompt
          return auto_prompt
        end

        Thor::Base.shell.new.yes?(prompt)
      end

      private

      def auto_prompt(prompt, options)
        options = options.with_indifferent_access
        prompt = Utils.strip_escapes(prompt)
        @auto_prompt ||= begin
          value = options.dig(:prompts, prompt) || options.dig(:prompts, :any)
          value = (value == 'true' unless value.nil?)
          value
        end
      end
    end
  end
end
