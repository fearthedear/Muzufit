class User < ActiveRecord::Base
  has_many :cpostings,
   foreign_key: "user_id",
   dependent: :destroy  #if user is destroyed, all cpostings go out of the window too

   has_many :subscriptions,
            foreign_key: "subscriber_id",
            dependent: :destroy

    has_many :templates,
              foreign_key: "user_id",
              dependent: :destroy

	  attr_accessor :remember_token, :activation_token
      before_save   :downcase_email
      before_create :create_activation_digest


	validates :name, presence: true, length: {maximum: 50}
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

	validates :password, presence: true, length: {minimum: 6}

	has_secure_password

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
  	SecureRandom.urlsafe_base64
  end


  def remember
  	self.remember_token = User.new_token
  	update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def subscribed?(post)
      Subscription.where(post_id: post.id,
                 subscriber_id: self.id).exists?
  end
  private
    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase
    end

    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

end
