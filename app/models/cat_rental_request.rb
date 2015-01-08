# == Schema Information
#
# Table name: cat_rental_requests
#
#  id         :integer          not null, primary key
#  cat_id     :integer          not null
#  start_date :date             not null
#  end_date   :date             not null
#  status     :string           default("PENDING"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CatRentalRequest < ActiveRecord::Base
  validates :cat_id, :start_date, :end_date, :status, :user_id, presence: true
  validates :status, inclusion: { in: ['PENDING', 'APPROVED', 'DENIED'] }
  validate :overlapping_approved_requests
  validate :start_before_end



  belongs_to(
    :cat,
    class_name: "Cat",
    foreign_key: :cat_id,
    primary_key: :id
  )

  has_one(
    :owner,
    through: :cat,
    source: :owner
  )

  belongs_to(
    :requester,
    class_name: 'User',
    foreign_key: :user_id,
    primary_key: :id
  )

  def approve!
    raise "not pending" unless self.status == "PENDING"
    transaction do
      self.status = "APPROVED"
      save!
      overlapping_pending_requests.each{ |request| request.deny! }
    end
  end

  def deny!
    self.status = "DENIED"
    save
  end

  private

  def overlapping_requests
    cat = Cat.find(cat_id)
    rental_requests = CatRentalRequest.where(cat_id: cat.id).
      where('(start_date <= :request_start AND :request_start <= end_date OR
              start_date <= :request_end AND :request_end <= end_date OR
              :request_start <= start_date AND end_date <= :request_end)
              AND id != :request_id',
            {request_start: start_date, request_end: end_date, request_id: id })
  end

  def overlapping_approved_requests
    requests = overlapping_requests.select { |request| request.status == 'APPROVED' && self.status == 'APPROVED'}
    errors[:overlap_conflict] = "Can't overlap approved requests!" unless requests.empty?
  end

  def overlapping_pending_requests
    overlapping_requests.select { |request| request.status == "PENDING"}
  end

  def start_before_end
    return if (!start_date.nil? && !end_date.nil?) && start_date < end_date
    errors[:start_date] << 'Must come before end date'
    errors[:end_date] << 'Must come after start date'
  end

end
