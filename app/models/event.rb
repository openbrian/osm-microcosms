# == Schema Information
#
# Table name: events
#
#  id           :bigint(8)        not null, primary key
#  title        :string           not null
#  moment       :datetime
#  location     :string
#  location_url :string
#  latitude     :float
#  longitude    :float
#  description  :text
#  microcosm_id :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Event < ApplicationRecord
  belongs_to :microcosm
  has_many :event_attendances
  has_many :event_organizers

  validates :moment, :datetime_format => true
  validates :location, :length => 1..255, :characters => true, :if => :has_location?
  validates :location_url, :length => 1..255, :if => :has_location_url?
  validates :location_url, :url => { :allow_blank => false }, :if => :has_location_url?
  validates :latitude, :numericality => true, :inclusion => { :in => -90..90 }
  validates :longitude, :numericality => true, :inclusion => { :in => -180..180 }
  validates :microcosm, :presence => true


  def has_location?
    !location.nil?
  end

  def has_location_url?
    !location_url.nil?
  end

  def attendees
    EventAttendance.where(:event_id => id, :intention => "Yes")
  end

  def organizers
    EventOrganizer.where(:event_id => id)
  end
end
