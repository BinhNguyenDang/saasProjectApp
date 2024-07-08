class Artifact < ApplicationRecord
  belongs_to :project

  has_one_attached :file

  MAX_FILESIZE = 10.megabytes
  validates_presence_of :name, :file
  validates_uniqueness_of :name

  # custom validation for file size
  validate :uploaded_file_size

  private

  def uploaded_file_size
    if file.attached? && file.blob.byte_size > self.class::MAX_FILESIZE
      errors.add(:file, "File size should be less than #{self.class::MAX_FILESIZE / 1.megabyte}MB")
    end
  end
end
