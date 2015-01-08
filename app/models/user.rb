class User < ActiveRecord::Base

  after_initialize :set_token

  has_many(
    :cats,
    class_name: "Cat",
    foreign_key: :user_id,
    primary_key: :id
  )

  has_many(
    :cat_rental_requests,
    class_name: 'CatRentalRequest',
    foreign_key: :user_id,
    primary_key: :id
  )

  has_many(
    :open_sessions,
    class_name: 'OpenSession',
    foreign_key: :user_id,
    primary_key: :id
  )

  def self.find_by_credentials(user_name, password)
      user = User.find_by(user_name: user_name)

      return nil if user.nil?

      user.is_password?(password) ? user : nil
  end

  def reset_session_token!
    session_token = SecureRandom::urlsafe_base64(16)
    # self.save!
    # self.session_token
    self.open_sessions.create(
      user_id: self.id,
      session_token: session_token,
      location: SecureRandom::urlsafe_base64(16)
    )
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def set_token
    self.session_token ||= SecureRandom::urlsafe_base64(16)
  end

end
