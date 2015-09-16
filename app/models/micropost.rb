class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> {order('created_at DESC')}
  validates :content, presence:true,length:{maximum:140}
  validates :user_id, presence: true

  def self.from_users_followed_by(user)
    followed_user_ids = "select followed_id from relationships where follower_id=:user_id"
    where("user_id in (#{followed_user_ids}) or user_id=:user_id",user_id:user.id)
  end
end
