# frozen_string_literal: true

module WebinarRu
  # Helpers functions
  module Utils
    module_function

    # @param [Integer] seconds
    # @return [String]
    def to_ical_duration(seconds)
      return unless seconds

      hours = seconds / 60 / 60
      minutes = (seconds - hours * 60 * 60) / 60
      seconds = seconds - minutes * 60 - hours * 60 * 60
      "PT#{hours}H#{minutes}M#{seconds}S"
    end

    # @param [Integer] seconds
    # @return [Hash]
    # @example
    #   to_webinar_time(seconds) #=>
    #   {:date=>{:year=>2020, :month=>12, :day=>1}, :time=>{:hour=>12, :minute=>30}}
    def to_webinar_time(seconds, timezone:)
      return unless seconds

      time = Time.at(seconds, in: TZInfo::Timezone.get(timezone))
      {
        date: { year: time.year, month: time.month, day: time.day },
        time: { hour: time.hour, minute: time.min }
      }
    end

    # Convert a string from "something_like_this" to "somethingLikeThis"
    # @param [String] underscored_word
    # @return [String]
    def camelize(underscored_word)
      underscored_word.gsub(/(?:_)(.)/) { Regexp.last_match(1).upcase }
    end

    # camelize all hash keys
    # @param [Hash] hash
    # @return [Hash]
    def camelize_keys(hash) # rubocop:disable Metrics/MethodLength
      hash.each.with_object({}) do |(key, val), obj|
        obj[camelize(key.to_s)] =
          case val
          when Hash
            camelize_keys(val)
          when Array
            val.map do |item|
              item.instance_of?(Hash) ? camelize_keys(item) : item
            end
          else
            val
          end
      end
    end

    def clip_array_brackets(param)
      param.gsub(/\[\](\[\d\])/, '\1')
    end

    # symbolize all hash keys
    # @param [Hash] hash
    # @return [Hash]
    def symbolize_keys(hash) # rubocop:disable Metrics/MethodLength
      hash.each.with_object({}) do |(key, val), obj|
        obj[key.to_sym] =
          case val
          when Hash
            symbolize_keys(val)
          when Array
            val.map do |item|
              item.instance_of?(Hash) ? symbolize_keys(item) : item
            end
          else
            val
          end
      end
    end
  end
end
