# frozen_string_literal: true

class RubyLinter < BaseLinter
  def self.linter_command
    "bundle exec rubocop --config #{Rails.root.join('.rubocop.yml')} --format json"
  end

  def self.offense_count(linter_output)
    linter_output.dig('summary', 'offense_count') || 0
  end
end
