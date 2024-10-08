# frozen_string_literal: true

FactoryBot.define do
  factory :migration_version, class: 'Doto::Models::MigrationVersion' do
    version { nil }
    options { {} }

    trait :with_current_version do
      version { Doto::Migration::VERSION }
    end

    initialize_with do
      Doto::Models::MigrationVersion.new(version: version, options: options)
    end

    after(:create) do |migration_version, _evaluator|
      migration_version.save!
    end
  end
end
