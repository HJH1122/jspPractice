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
