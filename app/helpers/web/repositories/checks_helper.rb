# frozen_string_literal: true

module Web::Repositories::ChecksHelper
  def parse_check_output(check_output, linter)
    case linter
    when 'eslint'
      format_eslint_output(check_output)
    when 'rubocop'
      format_rubocop_output(check_output)
    else
      {}
    end
  end

  def issues_count(check_output, linter)
    case linter
    when 'rubocop'
      if check_output.is_a?(Hash)
        check_output.fetch('files', []).size
      else
        0
      end
    else
      check_output.size
    end
  end

  private

  def format_eslint_output(output)
    formatted_output = {}
    output.each do |issue|
      next if issue['messages'].empty?

      file_path = issue['filePath']
      formatted_output[file_path] = []
      issue['messages'].each do |issue_messages|
        formatted_output[file_path].append(
          {
            message: issue_messages['message'],
            rule: 'N/A',
            line_column: "#{issue_messages['line']}:#{issue_messages['column']}"
          }
        )
      end
    end
    formatted_output
  end

  def format_rubocop_output(output)
    return {} if output.empty?

    formatted_output = {}
    output['files'].each do |file|
      next if file['offenses'].empty?

      file_path = file['path']
      formatted_output[file_path] = []
      file['offenses'].each do |offence|
        formatted_output[file_path].append(
          {
            message: offence['message'],
            rule: offence['cop_name'],
            line_column: "#{offence['location']['line']}:#{offence['location']['column']}"
          }
        )
      end
    end
    formatted_output
  end
end
