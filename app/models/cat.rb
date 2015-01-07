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
  validates :birth_date, :color, :name, :sex, presence: true
  validates :color, inclusion: { in: ["black", "white", "orange"],
    message: "cat can only be black, white, or orange" }
  validates :sex, inclusion: { in: ["m", "f"],
    message: "cat has to be male or female" }

  has_many(
    :rental_requests,
    class_name: "CatRentalRequest",
    foreign_key: :cat_id,
    primary_key: :id,
    dependent: :destroy
  )

  def age
    ((Time.now - birth_date.to_time)/(3600*24*365)).round(2)
  end
end
