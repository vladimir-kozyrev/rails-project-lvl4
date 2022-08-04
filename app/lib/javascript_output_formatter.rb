# frozen_string_literal: true

class JavascriptOutputFormatter
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
end
