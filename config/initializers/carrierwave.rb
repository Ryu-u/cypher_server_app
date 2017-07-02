if Rails.env.test? or Rails.env.cucumber?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
    config.permissions = 0666
    config.directory_permissions = 0777
    config.validate_download = false
  end
end