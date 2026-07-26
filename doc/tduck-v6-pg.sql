-- ================================================================
-- TDuck Platform v6 - PostgreSQL Database Schema
-- 基于 tduck-v6.sql (MySQL) 转换而来
-- 适配：PostgreSQL 13+ / Neon / Supabase 等
-- ================================================================

-- 扩展（如使用 uuid-ossp 可取消注释）
-- CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ================================================================
-- Table structure for ac_user
-- ================================================================
DROP TABLE IF EXISTS ac_user CASCADE;
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
COMMENT ON TABLE  ac_user IS '用户表';
COMMENT ON COLUMN ac_user.name IS '姓名';
COMMENT ON COLUMN ac_user.gender IS '性别：0未知 1男 2女';
COMMENT ON COLUMN ac_user.deleted IS '状态 0正常 1删除';

INSERT INTO ac_user (id, name, avatar, gender, email, phone_number, password, reg_channel,
                     last_login_channel, last_login_time, last_login_ip, password_type, deleted,
                     create_time, update_time)
VALUES (1, 'admin', '', 1, 'admin@tduckcloud.com', NULL, '$2a$10$FgOTdkh3qVLE9DNgD4XzDu2PCJB3QtnGbriBPaMhMKTVWM9XYsiIm',
        '1', 2, '2023-04-06 09:35:22', '172.17.0.1', 1, 0, '2021-06-13 13:49:25', '2023-04-06 09:35:22');

SELECT setval('ac_user_id_seq', (SELECT MAX(id) FROM ac_user));

-- ================================================================
-- Table structure for ac_user_authorize
-- ================================================================
DROP TABLE IF EXISTS ac_user_authorize CASCADE;
CREATE TABLE ac_user_authorize (
    id          BIGSERIAL PRIMARY KEY,
    type        SMALLINT        NOT NULL,
    app_id      VARCHAR(150),
    open_id     VARCHAR(150)    NOT NULL,
    user_name   VARCHAR(255)    NOT NULL,
    user_id     BIGINT,
    user_info   JSONB,
    create_time TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_open_id_type UNIQUE (open_id, type)
);
COMMENT ON TABLE ac_user_authorize IS '第三方用户授权信息';
COMMENT ON COLUMN ac_user_authorize.type IS '第三方平台类型';

-- ================================================================
-- Table structure for ac_user_token
-- ================================================================
DROP TABLE IF EXISTS ac_user_token CASCADE;
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
COMMENT ON TABLE ac_user_token IS '用户Token表';
COMMENT ON COLUMN ac_user_token.type IS '类型';

-- ================================================================
-- Table structure for fm_form_template
-- ================================================================
DROP TABLE IF EXISTS fm_form_template CASCADE;
CREATE TABLE fm_form_template (
    id          BIGSERIAL PRIMARY KEY,
    form_key    VARCHAR(50)     NOT NULL,
    cover_img   VARCHAR(100),
    name        TEXT            NOT NULL,
    description TEXT,
    category_id INTEGER         NOT NULL,
    scheme      JSONB,
    status      SMALLINT        NOT NULL DEFAULT 0,
    update_time TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    create_time TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE fm_form_template IS '表单模板';
COMMENT ON COLUMN fm_form_template.form_key IS '模板唯一标识';
COMMENT ON COLUMN fm_form_template.status IS '状态';

-- ================================================================
-- Table structure for fm_form_template_category
-- ================================================================
DROP TABLE IF EXISTS fm_form_template_category CASCADE;
CREATE TABLE fm_form_template_category (
    id          BIGSERIAL PRIMARY KEY,
    name        VARCHAR(50)     NOT NULL,
    sort        INTEGER,
    update_time TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    create_time TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE fm_form_template_category IS '模板分类';

-- ================================================================
-- Table structure for fm_form_theme
-- ================================================================
DROP TABLE IF EXISTS fm_form_theme CASCADE;
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
COMMENT ON TABLE fm_form_theme IS '主题外观模板';
COMMENT ON COLUMN fm_form_theme.style IS '主题风格';

-- ================================================================
-- Table structure for fm_form_theme_category
-- ================================================================
DROP TABLE IF EXISTS fm_form_theme_category CASCADE;
CREATE TABLE fm_form_theme_category (
    id          BIGSERIAL PRIMARY KEY,
    name        VARCHAR(50)     NOT NULL,
    sort        INTEGER,
    create_time TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE fm_form_theme_category IS '主题分类';

-- ================================================================
-- Table structure for fm_user_form
-- ================================================================
DROP TABLE IF EXISTS fm_user_form CASCADE;
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
COMMENT ON TABLE fm_user_form IS '用户表单';
COMMENT ON COLUMN fm_user_form.form_key IS '表单唯一标识';
COMMENT ON COLUMN fm_user_form.is_deleted IS '是否删除 0否 1是';
COMMENT ON COLUMN fm_user_form.is_folder IS '是否文件夹';

CREATE INDEX idx_fm_user_form_user_id ON fm_user_form(user_id);

-- ================================================================
-- Table structure for fm_user_form_auth
-- ================================================================
DROP TABLE IF EXISTS fm_user_form_auth CASCADE;
CREATE TABLE fm_user_form_auth (
    id              BIGSERIAL PRIMARY KEY,
    form_key        VARCHAR(50)     NOT NULL,
    auth_group_id   BIGINT,
    user_id_list    JSONB,
    role_id_list    JSONB,
    dept_id_list    JSONB,
    update_time     TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    create_time     TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_form_key_auth_group UNIQUE (form_key, auth_group_id)
);
COMMENT ON TABLE fm_user_form_auth IS '表单授权对象';

-- ================================================================
-- Table structure for fm_user_form_data
-- ================================================================
DROP TABLE IF EXISTS fm_user_form_data CASCADE;
CREATE TABLE fm_user_form_data (
    id                  BIGSERIAL PRIMARY KEY,
    form_key            VARCHAR(100)    NOT NULL,
    serial_number       INTEGER,
    original_data       JSONB,
    submit_ua           JSONB,
    submit_os           VARCHAR(50),
    submit_browser      VARCHAR(50),
    submit_request_ip   VARCHAR(50),
    submit_address      VARCHAR(50),
    complete_time       INTEGER,
    wx_open_id          VARCHAR(100),
    wx_user_info        JSONB,
    ext_value           VARCHAR(255),
    create_time         TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    create_by           VARCHAR(255),
    update_time         TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    update_by           VARCHAR(255)
);
COMMENT ON TABLE fm_user_form_data IS '表单收集数据结果';
COMMENT ON COLUMN fm_user_form_data.form_key IS '表单key';

CREATE INDEX idx_fm_user_form_data_form_key ON fm_user_form_data(form_key);

-- ================================================================
-- Table structure for fm_user_form_item
-- ================================================================
DROP TABLE IF EXISTS fm_user_form_item CASCADE;
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
    scheme          JSONB,
    reg_list        JSONB,
    update_time     TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    create_time     TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE fm_user_form_item IS '表单项';
COMMENT ON COLUMN fm_user_form_item.is_display_type IS '展示类型组件';
COMMENT ON COLUMN fm_user_form_item.is_hide_type IS '隐藏类型组件';
COMMENT ON COLUMN fm_user_form_item.is_special_type IS '特殊处理类型';

CREATE INDEX idx_fm_user_form_item_form_key ON fm_user_form_item(form_key);

-- ================================================================
-- Table structure for fm_user_form_logic
-- ================================================================
DROP TABLE IF EXISTS fm_user_form_logic CASCADE;
CREATE TABLE fm_user_form_logic (
    id          BIGSERIAL PRIMARY KEY,
    form_key    VARCHAR(100)    NOT NULL,
    scheme      JSONB,
    create_time TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_logic_form_key UNIQUE (form_key)
);
COMMENT ON TABLE fm_user_form_logic IS '表单逻辑';

-- ================================================================
-- Table structure for fm_user_form_setting
-- ================================================================
DROP TABLE IF EXISTS fm_user_form_setting CASCADE;
CREATE TABLE fm_user_form_setting (
    id          BIGSERIAL PRIMARY KEY,
    form_key    VARCHAR(100)    NOT NULL,
    settings    JSONB,
    update_time TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    create_time TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_setting_form_key UNIQUE (form_key)
);
COMMENT ON TABLE fm_user_form_setting IS '表单设置表';

-- ================================================================
-- Table structure for fm_user_form_theme
-- ================================================================
DROP TABLE IF EXISTS fm_user_form_theme CASCADE;
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
COMMENT ON TABLE fm_user_form_theme IS '表单主题配置';

-- ================================================================
-- Table structure for fm_user_form_view_count
-- ================================================================
DROP TABLE IF EXISTS fm_user_form_view_count CASCADE;
CREATE TABLE fm_user_form_view_count (
    id          BIGSERIAL PRIMARY KEY,
    form_key    VARCHAR(50)     NOT NULL,
    count       INTEGER         NOT NULL DEFAULT 0,
    update_time TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    create_time TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_view_form_key UNIQUE (form_key)
);
COMMENT ON TABLE fm_user_form_view_count IS '用户表单查看次数';

-- ================================================================
-- Table structure for sys_env_config
-- ================================================================
DROP TABLE IF EXISTS sys_env_config CASCADE;
CREATE TABLE sys_env_config (
    id          BIGSERIAL PRIMARY KEY,
    env_key     VARCHAR(100)    NOT NULL DEFAULT '',
    env_value   JSONB           NOT NULL,
    update_time TIMESTAMP,
    create_time TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE sys_env_config IS '系统环境配置表';
COMMENT ON COLUMN sys_env_config.env_key IS '配置key';
COMMENT ON COLUMN sys_env_config.env_value IS '参数键值';

INSERT INTO sys_env_config (id, env_key, env_value, update_time, create_time)
VALUES (9, 'systemInfoConfig',
        '{"webBaseUrl": "", "openWxMpLogin": false}'::jsonb,
        '2023-04-04 14:33:29', '2023-04-06 21:19:21');

INSERT INTO sys_env_config (id, env_key, env_value, update_time, create_time)
VALUES (14, 'fileEnvConfig',
        '{"ossType": "LOCAL"}'::jsonb,
        '2023-03-26 14:34:38', '2023-04-04 22:48:43');

SELECT setval('sys_env_config_id_seq', (SELECT MAX(id) FROM sys_env_config));

-- ================================================================
-- Table structure for wx_mp_user
-- ================================================================
DROP TABLE IF EXISTS wx_mp_user CASCADE;
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
COMMENT ON TABLE wx_mp_user IS '微信公众号用户';
COMMENT ON COLUMN wx_mp_user.is_subscribe IS '是否关注';

CREATE INDEX idx_wx_mp_user_union_id ON wx_mp_user(union_id);
CREATE INDEX idx_wx_mp_user_open_id ON wx_mp_user(open_id);

-- ================================================================
-- Table structure for webhook_config
-- ================================================================
DROP TABLE IF EXISTS webhook_config CASCADE;
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
COMMENT ON TABLE webhook_config IS 'Webhook配置表';
COMMENT ON COLUMN webhook_config.request_type IS 'Webhook请求类型，如POST、GET等';

CREATE INDEX idx_webhook_config_source ON webhook_config(source_type, source_id);

-- ================================================================
-- Table structure for webhook_event
-- ================================================================
DROP TABLE IF EXISTS webhook_event CASCADE;
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
COMMENT ON TABLE webhook_event IS 'Webhook事件表';
COMMENT ON COLUMN webhook_event.status IS 'Webhook事件状态，如pending、success、failed等';

CREATE INDEX idx_webhook_event_config ON webhook_event(webhook_config_id);

-- ================================================================
-- End of TDuck v6 PostgreSQL Schema
-- ================================================================
