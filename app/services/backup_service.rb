# backup_service
class BackupService
  # -----------------------------------------------------------------
  # Const
  # -----------------------------------------------------------------
  ZIP_FILE_NAME_SUFFIX = '.zip'.freeze
  DIR_NAME = 'your_tales'.freeze
  TEXT_FILE_SUFFIX = '.txt'.freeze

  # -----------------------------------------------------------------
  # Create
  # -----------------------------------------------------------------
  def self.create(user_id)
    file_name, zip_data = '', nil
    Backup.transaction do
      file_name, temp_file, tales = pre_create(user_id)
      begin
        zip_data = make_zip_file(temp_file, tales)
      ensure
        file_delete(temp_file)
      end
    end
    [file_name, zip_data]
  end

  # -----------------------------------------------------------------
  # Read
  # -----------------------------------------------------------------
  def self.read(user_id)
    BackupRepository.latest(user_id)
  end

  # -----------------------------------------------------------------
  # Support
  # -----------------------------------------------------------------
  class << self
    private

    def pre_create(user_id)
      filename = zip_file_name
      temp_file = Tempfile.new(filename)
      tales = TaleRepository.all(user_id)
      [filename, temp_file, tales]
    end

    def zip_file_name
      name = ''
      condition = true
      index = 0
      while condition
        index += 1
        name = digest_token(32)
        condition = BackupRepository.exists(name)
        raise Exception if index >= 10
      end
      name + ZIP_FILE_NAME_SUFFIX
    end

    def digest_token(length)
      tmp_token = SecureRandom.urlsafe_base64
      digest_token = Digest::MD5::hexdigest(tmp_token.to_s)
      digest_token[0..(length - 1)]
    end

    def make_zip_file(temp_file, tales)
      Zip::File.open(temp_file.path, Zip::File::CREATE) do |zip|
        zip.mkdir(DIR_NAME)
        tales.each { |tale| zip.get_output_stream(tale_file_name(tale)) { |s| tale_file_content(s, tale) } }
      end
      File.read(temp_file.path)
    end

    def tale_file_name(tale)
      DIR_NAME + File::SEPARATOR + tale.view_number.to_s + TEXT_FILE_SUFFIX
    end

    def tale_file_content(s, tale)
      # todo implement
      s.print(tale.content)
    end

    def file_delete(temp_file)
      temp_file.close
      temp_file.unlink
    end
  end
end
