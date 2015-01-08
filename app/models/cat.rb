# == Schema Information
#
# Table name: cats
#
#  id          :integer          not null, primary key
#  birth_date  :date             not null
#  color       :string           not null
#  name        :string           not null
#  sex         :string           not null
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Cat < ActiveRecord::Base
  include ActionView::Helpers::DateHelper

  CAT_COLORS = ["black", "white", "orange"]

  validates :birth_date, :color, :name, :sex, presence: true
  validates :color, inclusion: { in: CAT_COLORS,
    message: "cat can only be black, white, or orange" }
  validates :sex, inclusion: { in: ["m", "f"],
    message: "cat has to be male or female" }

  belongs_to(
      :owner,
      class_name: "User",
      foreign_key: :user_id,
      primary_key: :id
    )

  has_many(
    :rental_requests,
    class_name: "CatRentalRequest",
    foreign_key: :cat_id,
    primary_key: :id,
    dependent: :destroy
  )

  def age
    time_ago_in_words(birth_date)
  end
end
