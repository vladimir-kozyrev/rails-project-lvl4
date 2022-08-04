# frozen_string_literal: true

class RubyOutputFormatter
  def self.format_output(linter_output)
    return {} if linter_output.empty?

    formatted_output = {}
    linter_output['files'].each do |file|
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
