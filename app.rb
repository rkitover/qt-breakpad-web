require 'fileutils'
require 'sqlite3'
require 'rack/app'

class QtBreakpadCrashReportReceiver < Rack::App
  def initialize
    @DB_SCHEMA_FILE = 'schema.sql'
    @DB_FILE        = 'reports.db'
    @MINIDUMPS_PATH = 'minidumps'

    load_schema = !File.file?(@DB_FILE)

    @db = SQLite3::Database.new @DB_FILE

    @db.execute IO.read(@DB_SCHEMA_FILE) if load_schema

    @cwd = Dir.pwd

    FileUtils.mkdir_p(@MINIDUMPS_PATH)
  end

  post '/crash_report' do
    fields = %w[
      Email Comments StartupTime Vendor InstallTime Add-ons BuildID
      SecondsSinceLastCrash OrganizationName ProductName URL Theme Version
      CrashTime Throttleable
    ]

    @db.execute <<~'SQL', request.POST.fetch_values(*fields)
      INSERT INTO report (
          email_address, comments, startup_time, vendor, install_time, add_ons,
          build_id, seconds_since_last_crash, organization_name, product_name,
          url, theme, version, crash_time, throttleable
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    SQL

    id = @db.last_insert_row_id

    dump_path = File.join(@cwd, @MINIDUMPS_PATH, "#{id}.dmp")

    FileUtils.copy_file(request.POST.dig('upload_file_minidump', :tempfile), dump_path)

    @db.execute 'UPDATE report SET dump_file_path = ? WHERE report_id = ?', [ dump_path, id ]
  end
end
