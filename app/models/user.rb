class User < ActiveRecord::Base
  has_many :family_notes

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :email, :permission_level, presence: true
  validates :password, :password_confirmation, length: { minimum: 5 }, allow_blank: true, on: :update

  def admin?
    permission_level == "Admin"
  end

  def full_name
    [first_name, middle_name, last_name].join(' ')
  end
end
