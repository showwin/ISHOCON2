ALTER TABLE users ADD INDEX (name, address, mynumber);
ALTER TABLE candidates ADD INDEX (political_party);
ALTER TABLE votes ADD COLUMN count int(4) NOT NULL;
ALTER TABLE votes ADD INDEX (candidate_id, count);
CREATE TABLE candidate_keywords
(
    id           int(11) NOT NULL AUTO_INCREMENT,
    candidate_id int(11) NOT NULL,
    content      text    NOT NULL,
    count        int(4)  NOT NULL,
    PRIMARY KEY (id),
    KEY candidate_id (candidate_id),
    KEY candidate_id_content (candidate_id, content(255)),
    KEY candidate_id_count (candidate_id, count)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4;
