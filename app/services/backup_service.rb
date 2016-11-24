# backup_service
class BackupService
  # -----------------------------------------------------------------
  # Library
  # -----------------------------------------------------------------
  require 'zip'

  # -----------------------------------------------------------------
  # Const
  # -----------------------------------------------------------------
  DIR_NAME_PREFIX = Constants::PRODUCT_NAME_FOR_TITLE.downcase.freeze
  ZIP_FILE_NAME_SUFFIX = '.zip'.freeze
  TEXT_FILE_SUFFIX = '.txt'.freeze
  CONTENT_SEPARATOR = ('-' * 64).freeze

  # -----------------------------------------------------------------
  # Facade
  # -----------------------------------------------------------------
  def self.create(user)
    file_name, temp_file, tales = ready(user)
    begin
      zip_data = make_zip_file(temp_file, tales, user)
    ensure
      file_delete(temp_file)
    end
    [file_name, zip_data]
  end

  # -----------------------------------------------------------------
  # Support
  # -----------------------------------------------------------------
  class << self
    private

    def ready(user)
      filename = dir_name(user) + ZIP_FILE_NAME_SUFFIX
      temp_file = Tempfile.new(filename)
      tales = TaleRepository.all(user.id)
      [filename, temp_file, tales]
    end

    def dir_name(user)
      DIR_NAME_PREFIX + '_' + local_time_shorten(Time.now, user)
    end

    def make_zip_file(temp_file, tales, user)
      Zip::File.open(temp_file.path, Zip::File::CREATE) do |zip|
        zip.mkdir(dir_name(user))
        tales.each do |tale|
          file_name = tale_file_name(tale, user)
          zip.get_output_stream(file_name) { |s| tale_file_content(s, tale, user) }
        end
      end
      File.read(temp_file.path)
    end

    def tale_file_name(tale, user)
      dir_name(user) + File::SEPARATOR + tale.view_number.to_s + TEXT_FILE_SUFFIX
    end

    def tale_file_content(s, tale, user)
      [
        CONTENT_SEPARATOR, '[title] ' + tale.title, CONTENT_SEPARATOR,
        '[tag] ' + tale.tags.map(&:name).join(','),
        '[score] ' + tale.scores.map(&:record_to_text).join(','),
        CONTENT_SEPARATOR,
        '[created at] ' + local_time(tale.created_at, user),
        '[updated at] ' + local_time(tale.updated_at, user),
        CONTENT_SEPARATOR, '[content]', CONTENT_SEPARATOR, tale.content
      ].concat(sequel_file_content(tale.sequels, user)).each { |i| s.puts(i) }
    end

    def sequel_file_content(sequels, user)
      array = [CONTENT_SEPARATOR, '[sequel]', CONTENT_SEPARATOR]
      sequels.each do |sequel|
        array << [
          '[number] ' + sequel.view_number.to_s,
          '[created at] ' + local_time(sequel.created_at, user),
          '[updated at] ' + local_time(sequel.updated_at, user),
          CONTENT_SEPARATOR, sequel.content, CONTENT_SEPARATOR
        ]
      end
      sequels.present? ? array : array.concat([CONTENT_SEPARATOR])
    end

    def local_time_shorten(time, user)
      time.in_time_zone(user_timezone(user)).strftime('%Y%m%d%H%M')
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
