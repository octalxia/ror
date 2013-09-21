class Micropost < ActiveRecord::Base
  belongs_to :user
# 表格 10.1：用户和微博关联后所得方法的简介
#micropost.user	返回该微博对应的用户对象
#user.microposts	返回该用户的所有微博数组
#user.microposts.create(arg)	创建一篇微博（user_id = user.id）
#user.microposts.create!(arg)	创建一篇微博（失败时抛出异常）
#user.microposts.build(arg)	生成一个新的微博对象（user_id = user.id）
  
  validates :content, presence: true, length: { maximum: 140 }
  default_scope -> { order('created_at DESC') }
  validates :user_id, presence: true
  
  # Returns microposts from the users being followed by the given user.
  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
          user_id: user.id)
  end
end
