#!/bin/sh

cat <<'EOF' | sqlite3 reports.db
create table report (
  report_id                     integer primary key,
  email_address                 text,
  comments                      text,
  startup_time                  integer,
  vendor                        text,
  install_time                  integer,
  add_ons                       text,
  build_id                      text,
  seconds_since_last_crash      integer,
  organization_name             text,
  product_name                  text,
  url                           text,
  theme                         text,
  version                       text,
  crash_time                    integer,
  throttleable                  integer,
  dump_file_path                text
)
EOF
