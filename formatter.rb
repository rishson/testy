require 'json'
require 'pathname'

class SidekickFormatter < RuboCop::Formatter::BaseFormatter
  attr_reader :output_hash

  def initialize(output)
    super
    @meta = []
  end

  def started(target_files)
  end

  def file_finished(file, offenses)
    @meta << hash_for_file(file, offenses)
  end

  def finished(inspected_files)
    output.write({ meta: @meta }.to_json)
  end

  def hash_for_file(file, offenses)
    offenses.map { |o| hash_for_offense(o) }
  end

  def hash_for_offense(offense)
    {
      message:  offense.message,
      kind: offense.cop_name,
      location: hash_for_location(offense)
    }
  end

  # TODO: Consider better solution for Offense#real_column.
  def hash_for_location(offense)
    {
      startLine: offense.line,
      startCharacter: offense.real_column - 1,
      endLine: offense.line,
      endCharacter: offense.real_column - 1,
    }
  end
end


