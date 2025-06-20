module MemberId
  extend ActiveSupport::Concern

  class MemberId
    @@characters ||= ("A".."N").to_a + ("P".."Z").to_a + ("1".."9").to_a
    @@length ||= 10
    class InvalidError < RuntimeError; end
    Message = "member ids must be a sequence #{@@length} characters long from the set [#{@@characters.join}]"
    def initialize(string = "")
      @value = sanitize string
      raise InvalidError, Message unless valid?
    end
    def valid?
      @value.length == @@length and @value.each_char.all? do |character|
        @@characters.include? character
      end
    end
    def to_s
      @value
    end
  private
    def sanitize(string)
      string = string.to_s.upcase
      if string.length < @@length
        pad string
      elsif string.length > @@length
        trim string
      else
        string
      end
    end
    def pad(string)
      until string.length >= @@length
        string += @@characters.sample
      end
      string
    end
    def trim(string)
      string[0..@@length-1]
    end
  end
end
