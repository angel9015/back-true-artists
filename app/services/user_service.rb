class UserService
  attr_reader :params

  def initialize(params = {})
    @params = params
  end

  def call
    if existing_user
      OpenStruct.new({ success?: true, payload: existing_user })
    else
      create_user
    end
  end

  def existing_user
    user = User.find_by(email: params[:email])
  end

  def create_user
    user = User.new(params)

    if user.save
      OpenStruct.new({ success?: true, payload: user })
    else
      OpenStruct.new({ success?: false, errors: user.errors.full_messages })
    end
  end
end
