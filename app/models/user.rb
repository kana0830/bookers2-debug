class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,:validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  # ＝＝フォロー＝＝
  has_many :relationships  #(foreign_key: 'user_id')が省略されてる
  # 「followings」：架空のモデル
  # 「through: :relationships」：中間テーブルはrelationships
  # 「source: :follow」：follow_idを参考にfollowingsモデルにアクセス
  # →user.followingsで、userが中間テーブルのrelationshipsを取得し、relationshipのfollow_idからフォローしているUser達を取得可能
  has_many :followings, through: :relationships, source: :follow
  # ＝＝フォロワー＝＝
  # 「reverse_of_relationships」：relationshipsの逆という意味
  # 「class_name: 'Relationship'」：中間テーブルはrelationships
  # 「foreighn_key: 'follow_id'」：relaitonshipsテーブルにアクセスする時、follow_idを参照する
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverse_of_relationships, source: :user
  # ※※※「foregin_key = 入口」「source = 出口」のような意味※※※

  # フォローしてるユーザーかどうかrelationshipsから探して、フォローしてなかったらフォローする
  def follow(other_user)
    unless self == other_user
      # 見つからなければself.relationships.create(follow_id: other_user.id)としてフォロー関係を保存(create = new + save)
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  # フォローしてるユーザーかどうかrelationshipsから探して、フォローしてたら解除する
  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  # ○○さんをフォローしてるかしてないかをtrue,falseで返すってこと？
  def following?(other_user)
    self.followings.include?(other_user)
  end


  #＝＝都道府県変換＝＝
  include JpPrefecture
  jp_prefecture :prefecture_code    
  
  def prefecture_name
    JpPrefecture::Prefecture.find(code: prefecture_code).try(:name)
  end
  
  def prefecture_name=(prefecture_name)
    self.prefecture_code = JpPrefecture::Prefecture.find(name: prefecture_name).code
  end
  

  attachment :profile_image, destroy: false

  #バリデーションは該当するモデルに設定する。エラーにする条件を設定できる。
  validates :name, presence: true, length: { minimum: 2, maximum: 20 }
  validates :introduction, length: { maximum: 50 }
end
