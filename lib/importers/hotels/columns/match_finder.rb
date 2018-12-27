# frozen_string_literal: true

require 'levenshtein'

# MatchFinder - Given a set of possible values and potential
# values for a column, figure out which of them can be inserted in via Levenshtein
# If potential_values are an array, then iterate over the array and look for matches
# If hash, then look in the hash_key_to_check and look for matches there
# Raise an error if unable to iterate through the potential values
module Importers
  module Hotels
    module Columns
      class MatchFinder
        attr_reader :potential_values, :possible_values, :hash_key_to_check, :error_message

        def initialize(potential_values:, possible_values:, hash_key_to_check:, error_message:)
          @potential_values = potential_values
          @possible_values = possible_values
          @hash_key_to_check = hash_key_to_check
          @error_message = error_message
        end

        def call
          find_column_value_matches.compact.uniq
        end

        private

        def find_column_value_matches
          case potential_values
          when Array
            potential_values.map { |potential_value| find_match_from_possible_values(potential_value) }
          when Hash
            raise HotelsError, error_message unless potential_values[hash_key_to_check].present?

            potential_values[hash_key_to_check].map { |potential_value| find_match_from_possible_values(potential_value) }
          else
            raise HotelsError, error_message
          end
        end

        def find_match_from_possible_values(potential_value)
          possible_values.detect do |possible_value|
            if possible_value.is_a?(String)
              levenshtein_match?(potential_value, possible_value)
            else
              matched_value, value_synonyms = possible_value

              value_synonyms.detect do |value_synonym|
                return matched_value if levenshtein_match?(potential_value, value_synonym)
              end
            end
          end
        end

        def levenshtein_match?(potential, possible)
          Levenshtein.distance(possible.downcase, potential.downcase) < 2
        end
      end
    end
  end
end
