class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  acts_as_votable
  validates :content, presence: true

  
end
