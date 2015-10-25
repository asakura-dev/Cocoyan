# coding: utf-8
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:twitter]
  validates :username, presence: true, uniqueness: true

  def self.from_omniauth(auth)
    # providerとuidでUserレコードを取得する
    # 存在しない場合は、ブロック内のコードを実行して作成する
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.new(username: auth.info.nickname,
                      provider: auth.provider,
                      uid: auth.uid,
                      email: User.create_unique_email,
                      password: Devise.friendly_token[0,20],
                      oauth_token: auth.credentials.token,
                      oauth_token_secret: auth.credentials.secret
                     )
      #user.skip_confirmation!
      user.save
    end
    user
  end

  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end
  def password_required?
    super && provider.blank?
  end
  def self.create_unique_string
    SecureRandom.uuid
  end

  def self.create_unique_email
    User.create_unique_string + "@example.com"
  end
end
