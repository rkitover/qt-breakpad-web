CREATE TABLE report (
    report_id                     INTEGER PRIMARY KEY,
    email_address                 TEXT,
    comments                      TEXT,
    startup_time                  INTEGER,
    vendor                        TEXT,
    install_time                  INTEGER,
    add_ons                       TEXT,
    build_id                      TEXT,
    seconds_since_last_crash      INTEGER,
    organization_name             TEXT,
    product_name                  TEXT,
    url                           TEXT,
    theme                         TEXT,
    version                       TEXT,
    crash_time                    INTEGER,
    throttleable                  INTEGER,
    dump_file_path                TEXT
);
