require 'fileutils'
require 'sqlite3'
require 'rack/app'

class QtBreakpadCrashReportReceiver < Rack::App
  def initialize
    @db = SQLite3::Database.new 'reports.db'

    @cwd = Dir.pwd

    FileUtils.mkdir_p('minidumps')
  end

  post '/crash_reports/submit' do
    @db.execute \
      'insert into report (' \
        'email_address,' \
	'comments,' \
        'startup_time,' \
        'vendor,' \
        'install_time,' \
        'add_ons,' \
	'build_id,' \
	'seconds_since_last_crash,' \
	'organization_name,' \
	'product_name,' \
	'url,' \
	'theme,' \
	'version,' \
	'crash_time,' \
	'throttleable' \
      ') values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', \
      [ ['Email', 'Comments', 'StartupTime', 'Vendor', 'InstallTime', \
	 'Add-ons', 'BuildID', 'SecondsSinceLastCrash', 'OrganizationName', \
	 'ProductName', 'URL', 'Theme', 'Version', 'CrashTime', \
	 'Throttleable'].map { |p| request.POST[p] } ]

    id=nil

    @db.execute('select last_insert_rowid()') do |row|
      id = row[0]
    end

    FileUtils.copy_file(request.POST['upload_file_minidump'][:tempfile], "minidumps/#{id}.dmp")

    @db.execute 'update report set dump_file_path = ? where report_id = ?', [ \
      "#{@cwd}/minidumps/#{id}.dmp", id \
    ]
  end
end

