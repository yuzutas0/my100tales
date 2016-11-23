# backup_service
class BackupService
  # -----------------------------------------------------------------
  # Library
  # -----------------------------------------------------------------
  require 'zip'

  # -----------------------------------------------------------------
  # Const
  # -----------------------------------------------------------------
  DIR_NAME = Constants::PRODUCT_NAME_FOR_HEADER.downcase.freeze
  ZIP_FILE_NAME_SUFFIX = '.zip'.freeze
  TEXT_FILE_SUFFIX = '.txt'.freeze
  CONTENT_SEPARATOR = ('-' * 64).freeze

  # -----------------------------------------------------------------
  # Create
  # -----------------------------------------------------------------
  def self.create(user)
    file_name, zip_data = '', nil
    Backup.transaction do
      file_name, temp_file, tales = pre_create(user.id)
      begin
        zip_data = make_zip_file(temp_file, tales, user)
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
      filename = DIR_NAME + ZIP_FILE_NAME_SUFFIX
      temp_file = Tempfile.new(filename)
      tales = TaleRepository.all(user_id)
      [filename, temp_file, tales]
    end

    # todo: delete
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

    def make_zip_file(temp_file, tales, user)
      Zip::File.open(temp_file.path, Zip::File::CREATE) do |zip|
        zip.mkdir(DIR_NAME)
        tales.each { |tale| zip.get_output_stream(tale_file_name(tale)) { |s| tale_file_content(s, tale, user) } }
      end
      File.read(temp_file.path)
    end

    def tale_file_name(tale)
      DIR_NAME + File::SEPARATOR + tale.view_number.to_s + TEXT_FILE_SUFFIX
    end

    def tale_file_content(s, tale, user)
      # todo implement
      [
          CONTENT_SEPARATOR,
          '[title] ' + tale.title,
          CONTENT_SEPARATOR,
          '[created at] ' + local_time(tale.created_at, user),
          '[updated at] ' + local_time(tale.updated_at, user),
          CONTENT_SEPARATOR,
          '[tag] ',
          '[score] ',
          CONTENT_SEPARATOR,
          '[content]',
          CONTENT_SEPARATOR,
          tale.content,
          CONTENT_SEPARATOR
      ].each { |i| s.puts(i) }
    end

    # refs. ApplicationHelper#local_time
    def local_time(time, user)
      time.in_time_zone(user_timezone(user)).strftime('%Y-%m-%d %H:%M')
    end

    # refs. ApplicationHelper#user_timezone
    def user_timezone(user)
      tz = user.timezone
      tz = right_timezone?(tz) ? tz : 'Etc/GMT'
      TZInfo::Timezone.get(tz).identifier
    end

    # refs. ApplicationHelper#right_timezone?
    def right_timezone?(timezone)
      TZInfo::Timezone.all_identifiers.include?(timezone)
    end

    def file_delete(temp_file)
      temp_file.close
      temp_file.unlink
    end
  end
end
