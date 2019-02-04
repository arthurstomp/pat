module FrontMakeup
  class User
    attr_reader :user, :request
    def initialize(user, request)
      @user = user
      @request = request
    end

    def to_build_for
      Jbuilder.new do |o|
        o.email user.email
        o.username user.username
        o.jwt user.jwt
      end
    end
  end
end
