# frozen_string_literal: true

class JavascriptLinter < BaseLinter
  def self.linter_command
    eslint = Rails.root.join('node_modules/eslint/bin/eslint.js')
    "#{eslint} --config #{Rails.root.join('.eslintrc.yml')} --no-eslintrc --format json"
  end

  def self.format_output(linter_output)
    formatted_output = {}
    linter_output.each do |issue|
      next if issue['messages'].empty?

      file_path = issue['filePath']
      formatted_output[file_path] = []
      issue['messages'].each do |issue_messages|
        formatted_output[file_path].append(
          {
            message: issue_messages['message'],
            rule: issue_messages['ruleId'],
            line_column: "#{issue_messages['line']}:#{issue_messages['column']}"
          }
        )
      end
    end
    formatted_output
  end

  def self.offense_count(linter_output)
    linter_output.sum { |file| file['messages'].size }
  end
end
