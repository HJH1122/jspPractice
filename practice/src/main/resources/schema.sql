CREATE TABLE IF NOT EXISTS cms_category (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(100) NOT NULL,
    parent_id BIGINT REFERENCES cms_category(id) ON DELETE SET NULL,
    description TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_cms_category_slug_unique
    ON cms_category (LOWER(slug));
CREATE INDEX IF NOT EXISTS idx_cms_category_parent_id
    ON cms_category(parent_id);

ALTER TABLE IF EXISTS cms_post
    ADD COLUMN IF NOT EXISTS category_id BIGINT REFERENCES cms_category(id) ON DELETE SET NULL;

CREATE TABLE IF NOT EXISTS cms_tag (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(100) NOT NULL,
    description VARCHAR(500),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_cms_tag_slug_unique
    ON cms_tag (LOWER(slug));

CREATE TABLE IF NOT EXISTS cms_post_tag (
    post_id BIGINT NOT NULL REFERENCES cms_post(id) ON DELETE CASCADE,
    tag_id BIGINT NOT NULL REFERENCES cms_tag(id) ON DELETE CASCADE,
    PRIMARY KEY (post_id, tag_id)
);

CREATE TABLE IF NOT EXISTS cms_comment (
    id BIGSERIAL PRIMARY KEY,
    post_id BIGINT NOT NULL,
    author VARCHAR(100) NOT NULL,
    post_title VARCHAR(255),
    content TEXT NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'approved',
    report_count INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE cms_comment ALTER COLUMN status SET DEFAULT 'approved';
UPDATE cms_comment SET status = 'approved' WHERE status = 'pending';

CREATE TABLE IF NOT EXISTS cms_comment_report (
    id BIGSERIAL PRIMARY KEY,
    comment_id BIGINT NOT NULL REFERENCES cms_comment(id) ON DELETE CASCADE,
    reason VARCHAR(100) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_cms_comment_post_id ON cms_comment(post_id);
CREATE INDEX IF NOT EXISTS idx_cms_comment_status ON cms_comment(status);
CREATE INDEX IF NOT EXISTS idx_cms_comment_created_at ON cms_comment(created_at);
CREATE INDEX IF NOT EXISTS idx_cms_comment_report_comment_id ON cms_comment_report(comment_id);

CREATE TABLE IF NOT EXISTS cms_site_main_page_settings (
    singleton_id INTEGER PRIMARY KEY CHECK (singleton_id = 1),
    banner_title TEXT NOT NULL DEFAULT '',
    banner_description TEXT NOT NULL DEFAULT '',
    banner_image_url TEXT NOT NULL DEFAULT '',
    button_link_type VARCHAR(20) NOT NULL DEFAULT 'PAGE',
    button_link_target TEXT NOT NULL DEFAULT '',
    section_order TEXT NOT NULL DEFAULT 'FEATURED_PAGE,FEATURED_POSTS,RECENT_POSTS',
    visible_sections TEXT NOT NULL DEFAULT 'FEATURED_PAGE,FEATURED_POSTS,RECENT_POSTS',
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE cms_site_main_page_settings
    ADD COLUMN IF NOT EXISTS section_order TEXT NOT NULL DEFAULT 'FEATURED_PAGE,FEATURED_POSTS,RECENT_POSTS';

ALTER TABLE cms_site_main_page_settings
    ADD COLUMN IF NOT EXISTS button_link_target TEXT NOT NULL DEFAULT '';

ALTER TABLE cms_site_main_page_settings
    ADD COLUMN IF NOT EXISTS visible_sections TEXT NOT NULL DEFAULT 'FEATURED_PAGE,FEATURED_POSTS,RECENT_POSTS';

CREATE TABLE IF NOT EXISTS cms_site_menu (
    menu_id VARCHAR(50) PRIMARY KEY,
    menu_name VARCHAR(100) NOT NULL,
    parent_menu_id VARCHAR(50) REFERENCES cms_site_menu(menu_id) ON DELETE SET NULL,
    menu_type VARCHAR(20) NOT NULL DEFAULT 'PAGE' CHECK (menu_type IN ('PAGE', 'URL', 'GROUP')),
    page_id BIGINT,
    external_url VARCHAR(2000) NOT NULL DEFAULT '',
    display_pc BOOLEAN NOT NULL DEFAULT TRUE,
    display_mobile BOOLEAN NOT NULL DEFAULT TRUE,
    is_visible BOOLEAN NOT NULL DEFAULT TRUE,
    open_new_window BOOLEAN NOT NULL DEFAULT FALSE,
    display_order INTEGER NOT NULL,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO cms_site_menu (
    menu_id, menu_name, parent_menu_id, menu_type, page_id, external_url,
    display_pc, display_mobile, is_visible, open_new_window, display_order
)
VALUES
    ('about', '회사소개', NULL, 'PAGE', NULL, '', TRUE, TRUE, TRUE, FALSE, 1),
    ('greeting', '인사말', 'about', 'PAGE', NULL, '', TRUE, TRUE, TRUE, FALSE, 2),
    ('history', '연혁', 'about', 'PAGE', NULL, '', TRUE, TRUE, TRUE, FALSE, 3),
    ('location', '오시는 길', 'about', 'PAGE', NULL, '', TRUE, TRUE, FALSE, FALSE, 4),
    ('services', '서비스', NULL, 'GROUP', NULL, '', TRUE, TRUE, TRUE, FALSE, 5),
    ('services-intro', '서비스 소개', 'services', 'PAGE', NULL, '', TRUE, TRUE, TRUE, FALSE, 6),
    ('notices', '공지사항', NULL, 'PAGE', NULL, '', TRUE, TRUE, TRUE, FALSE, 7),
    ('contact', '문의하기', NULL, 'PAGE', NULL, '', TRUE, TRUE, TRUE, FALSE, 8)
ON CONFLICT (menu_id) DO NOTHING;
