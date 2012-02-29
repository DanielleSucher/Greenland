# for testing, via http://vcp.lithium3141.com/2011/04/advanced-rspec/
class InputFaker
    def initialize(strings)
        @strings = strings
    end 

    def gets
        next_string = @strings.shift
        next_string
    end 

    def self.with_fake_input(strings)
        $stdin = new(strings)
        yield
    ensure
        $stdin = STDIN
    end
end