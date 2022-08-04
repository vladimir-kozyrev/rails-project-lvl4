# frozen_string_literal: true

class JavascriptLinter < BaseLinter
  def self.linter_command
    eslint = Rails.root.join('node_modules/eslint/bin/eslint.js')
    "#{eslint} --config #{Rails.root.join('.eslintrc.yml')} --no-eslintrc --format json"
  end

  def self.offense_count(linter_output)
    linter_output.sum { |file| file['messages'].size }
  end
end
