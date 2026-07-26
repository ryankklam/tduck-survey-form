-- ================================================================
-- TDuck Platform v6 - PostgreSQL Database Schema
-- 适配：PostgreSQL 13+ / Neon / Supabase
-- ================================================================

-- 1. ac_user
DROP TABLE IF EXISTS ac_user;
CREATE TABLE ac_user (
    id                  BIGSERIAL PRIMARY KEY,
    name                VARCHAR(32)     NOT NULL DEFAULT '',
    avatar              VARCHAR(256)    NOT NULL DEFAULT '',
    gender              SMALLINT        NOT NULL DEFAULT 0,
    email               VARCHAR(100),
    phone_number        VARCHAR(11),
    password            VARCHAR(255),
    reg_channel         VARCHAR(255),
    last_login_channel   SMALLINT,
    last_login_time     TIMESTAMP,
    last_login_ip       VARCHAR(50),
    password_type       SMALLINT        DEFAULT 0,
    deleted             SMALLINT        DEFAULT 0,
    create_time         TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_time         TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO ac_user (id, name, avatar, gender, email, phone_number, password, reg_channel,
                     last_login_channel, last_login_time, last_login_ip, password_type, deleted,
                     create_time, update_time)
VALUES (1, 'admin', '', 1, 'admin@tduckcloud.com', NULL, '$2a$10$FgOTdkh3qVLE9DNgD4XzDu2PCJB3QtnGbriBPaMhMKTVWM9XYsiIm',
        '1', 2, '2023-04-06 09:35:22', '172.17.0.1', 1, 0, '2021-06-13 13:49:25', '2023-04-06 09:35:22');
SELECT setval('ac_user_id_seq', (SELECT MAX(id) FROM ac_user));

-- 2. ac_user_authorize
DROP TABLE IF EXISTS ac_user_authorize;
CREATE TABLE ac_user_authorize (
    id          BIGSERIAL PRIMARY KEY,
    type        SMALLINT        NOT NULL,
    app_id      VARCHAR(150),
    open_id     VARCHAR(150)    NOT NULL,
    user_name   VARCHAR(255)    NOT NULL,
    user_id     BIGINT,
    user_info   JSON,
    create_time TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_open_id_type UNIQUE (open_id, type)
);

-- 3. ac_user_token
DROP TABLE IF EXISTS ac_user_token;
CREATE TABLE ac_user_token (
    id          BIGSERIAL PRIMARY KEY,
    type        INTEGER         NOT NULL DEFAULT 0,
    user_id     BIGINT          NOT NULL,
    token       VARCHAR(255)    NOT NULL,
    expire_time TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    create_time TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_token UNIQUE (token)
);

-- 4. fm_form_template
DROP TABLE IF EXISTS fm_form_template;
CREATE TABLE fm_form_template (
    id          BIGSERIAL PRIMARY KEY,
    form_key    VARCHAR(50)     NOT NULL,
    cover_img   VARCHAR(100),
    name        TEXT            NOT NULL,
    description TEXT,
    category_id INTEGER         NOT NULL,
    scheme      JSON,
    status      SMALLINT        NOT NULL DEFAULT 0,
    update_time TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    create_time TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
);

-- 5. fm_form_template_category
DROP TABLE IF EXISTS fm_form_template_category;
CREATE TABLE fm_form_template_category (
    id          BIGSERIAL PRIMARY KEY,
    name        VARCHAR(50)     NOT NULL,
    sort        INTEGER,
    update_time TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    create_time TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
);

-- 6. fm_form_theme
DROP TABLE IF EXISTS fm_form_theme;
CREATE TABLE fm_form_theme (
    id              BIGSERIAL PRIMARY KEY,
    name            VARCHAR(50)     NOT NULL,
    style           BIGINT          NOT NULL,
    head_img_url    VARCHAR(255)    NOT NULL,
    background_img  VARCHAR(255),
    theme_color     VARCHAR(20),
    update_time     TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    create_time     TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
);

-- 7. fm_form_theme_category
DROP TABLE IF EXISTS fm_form_theme_category;
CREATE TABLE fm_form_theme_category (
    id          BIGSERIAL PRIMARY KEY,
    name        VARCHAR(50)     NOT NULL,
    sort        INTEGER,
    create_time TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
);

-- 8. fm_user_form
DROP TABLE IF EXISTS fm_user_form;
CREATE TABLE fm_user_form (
    id          BIGSERIAL PRIMARY KEY,
    form_key    VARCHAR(50)     NOT NULL,
    source_id   VARCHAR(255),
    source_type SMALLINT,
    name        TEXT            NOT NULL,
    description TEXT,
    user_id     BIGINT          NOT NULL,
    type        VARCHAR(10),
    status      SMALLINT        NOT NULL DEFAULT 0,
    is_deleted  SMALLINT        NOT NULL DEFAULT 0,
    is_folder   SMALLINT        DEFAULT 0,
    folder_id   BIGINT          DEFAULT 0,
    update_time TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    create_time TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_form_key UNIQUE (form_key)
);
CREATE INDEX idx_fm_user_form_user_id ON fm_user_form(user_id);

-- 9. fm_user_form_auth
DROP TABLE IF EXISTS fm_user_form_auth;
CREATE TABLE fm_user_form_auth (
    id              BIGSERIAL PRIMARY KEY,
    form_key        VARCHAR(50)     NOT NULL,
    auth_group_id   BIGINT,
    user_id_list    JSON,
    role_id_list    JSON,
    dept_id_list    JSON,
    update_time     TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    create_time     TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_form_key_auth_group UNIQUE (form_key, auth_group_id)
);

-- 10. fm_user_form_data
DROP TABLE IF EXISTS fm_user_form_data;
CREATE TABLE fm_user_form_data (
    id                  BIGSERIAL PRIMARY KEY,
    form_key            VARCHAR(100)    NOT NULL,
    serial_number       INTEGER,
    original_data       JSON,
    submit_ua           JSON,
    submit_os           VARCHAR(50),
    submit_browser      VARCHAR(50),
    submit_request_ip   VARCHAR(50),
    submit_address      VARCHAR(50),
    complete_time       INTEGER,
    wx_open_id          VARCHAR(100),
    wx_user_info        JSON,
    ext_value           VARCHAR(255),
    create_time         TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    create_by           VARCHAR(255),
    update_time         TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    update_by           VARCHAR(255)
);
CREATE INDEX idx_fm_user_form_data_form_key ON fm_user_form_data(form_key);

-- 11. fm_user_form_item
DROP TABLE IF EXISTS fm_user_form_item;
CREATE TABLE fm_user_form_item (
    id              BIGSERIAL PRIMARY KEY,
    form_key        VARCHAR(100)    NOT NULL,
    form_item_id    VARCHAR(50)     NOT NULL,
    type            VARCHAR(25)     NOT NULL,
    label           TEXT            NOT NULL,
    is_display_type SMALLINT        NOT NULL DEFAULT 0,
    is_hide_type    SMALLINT        NOT NULL DEFAULT 0,
    is_special_type SMALLINT        NOT NULL DEFAULT 0,
    show_label      SMALLINT        NOT NULL DEFAULT 0,
    default_value   VARCHAR(1000),
    required        SMALLINT        NOT NULL,
    placeholder     VARCHAR(255),
    sort            BIGINT          DEFAULT 0,
    span            INTEGER         NOT NULL DEFAULT 24,
    scheme          JSON,
    reg_list        JSON,
    update_time     TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    create_time     TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_fm_user_form_item_form_key ON fm_user_form_item(form_key);

-- 12. fm_user_form_logic
DROP TABLE IF EXISTS fm_user_form_logic;
CREATE TABLE fm_user_form_logic (
    id          BIGSERIAL PRIMARY KEY,
    form_key    VARCHAR(100)    NOT NULL,
    scheme      JSON,
    create_time TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_logic_form_key UNIQUE (form_key)
);

-- 13. fm_user_form_setting
DROP TABLE IF EXISTS fm_user_form_setting;
CREATE TABLE fm_user_form_setting (
    id          BIGSERIAL PRIMARY KEY,
    form_key    VARCHAR(100)    NOT NULL,
    settings    JSON,
    update_time TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    create_time TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_setting_form_key UNIQUE (form_key)
);

-- 14. fm_user_form_theme
DROP TABLE IF EXISTS fm_user_form_theme;
CREATE TABLE fm_user_form_theme (
    id               BIGSERIAL PRIMARY KEY,
    form_key         VARCHAR(100)    NOT NULL,
    submit_btn_text  VARCHAR(20),
    logo_img         VARCHAR(255),
    logo_position    VARCHAR(10),
    background_color VARCHAR(200),
    background_img   VARCHAR(200),
    show_title       SMALLINT        DEFAULT 1,
    show_describe    SMALLINT        DEFAULT 1,
    theme_color      VARCHAR(50),
    show_number      SMALLINT        DEFAULT 0,
    show_submit_btn  SMALLINT        DEFAULT 1,
    head_img_url     VARCHAR(255),
    update_time      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    create_time      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_theme_form_key UNIQUE (form_key)
);

-- 15. fm_user_form_view_count
DROP TABLE IF EXISTS fm_user_form_view_count;
CREATE TABLE fm_user_form_view_count (
    id          BIGSERIAL PRIMARY KEY,
    form_key    VARCHAR(50)     NOT NULL,
    count       INTEGER         NOT NULL DEFAULT 0,
    update_time TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    create_time TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_view_form_key UNIQUE (form_key)
);

-- 16. sys_env_config
DROP TABLE IF EXISTS sys_env_config;
CREATE TABLE sys_env_config (
    id          BIGSERIAL PRIMARY KEY,
    env_key     VARCHAR(100)    NOT NULL DEFAULT '',
    env_value   JSON            NOT NULL,
    update_time TIMESTAMP,
    create_time TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO sys_env_config (id, env_key, env_value, update_time, create_time)
VALUES (9, 'systemInfoConfig',
        CAST('{"webBaseUrl": "", "openWxMpLogin": false}' AS JSON),
        '2023-04-04 14:33:29', '2023-04-06 21:19:21');
INSERT INTO sys_env_config (id, env_key, env_value, update_time, create_time)
VALUES (14, 'fileEnvConfig',
        CAST('{"ossType": "LOCAL"}' AS JSON),
        '2023-03-26 14:34:38', '2023-04-04 22:48:43');
SELECT setval('sys_env_config_id_seq', (SELECT MAX(id) FROM sys_env_config));

-- 17. wx_mp_user
DROP TABLE IF EXISTS wx_mp_user;
CREATE TABLE wx_mp_user (
    id           SERIAL PRIMARY KEY,
    appid        VARCHAR(255)    NOT NULL,
    nickname     VARCHAR(255),
    sex          SMALLINT,
    head_img_url VARCHAR(255)    NOT NULL,
    union_id     VARCHAR(150),
    open_id      VARCHAR(150)    NOT NULL,
    country      VARCHAR(255),
    province     VARCHAR(255),
    city         VARCHAR(255),
    is_subscribe SMALLINT        DEFAULT 1,
    user_id      BIGINT,
    update_time  TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    create_time  TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_wx_mp_user_union_id ON wx_mp_user(union_id);
CREATE INDEX idx_wx_mp_user_open_id ON wx_mp_user(open_id);

-- 18. webhook_config
DROP TABLE IF EXISTS webhook_config;
CREATE TABLE webhook_config (
    id              BIGSERIAL PRIMARY KEY,
    hook_name       VARCHAR(50),
    source_type     VARCHAR(50)     NOT NULL,
    source_id       VARCHAR(200)    NOT NULL,
    url             VARCHAR(200)    NOT NULL,
    request_type    VARCHAR(20)     NOT NULL,
    enabled         SMALLINT        NOT NULL,
    other_options   TEXT,
    create_time     TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_time     TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_webhook_config_source ON webhook_config(source_type, source_id);

-- 19. webhook_event
DROP TABLE IF EXISTS webhook_event;
CREATE TABLE webhook_event (
    id                BIGSERIAL PRIMARY KEY,
    webhook_config_id BIGINT          NOT NULL,
    source_id         VARCHAR(200)    NOT NULL,
    event_type        VARCHAR(50)     NOT NULL,
    event_data        TEXT            NOT NULL,
    status            VARCHAR(20)     NOT NULL,
    retry_times       INTEGER         NOT NULL DEFAULT 0,
    last_error        TEXT,
    create_time       TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_time       TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_webhook_event_config ON webhook_event(webhook_config_id);

-- ================================================================
-- End of TDuck v6 PostgreSQL Schema
-- ================================================================
