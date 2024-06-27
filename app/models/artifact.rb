class Artifact < ApplicationRecord
  attr_accessor :upload
  belongs_to :project

  MAX_FILESIZE = 10.megabytes
  validates_presence_of :name, :upload
  validates_uniqueness_of :name

  # custom validation for file size
  validate :upload_file_size

  private

  def upload_file_size
    if upload
      errors.add(:upload, "File size must be less than #{self.class::MAX_FILESIZE}MB") unless upload.size <= self.class::MAX_FILESIZE
    end
  end
end
