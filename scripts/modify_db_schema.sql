ALTER TABLE users ADD INDEX (name, address, mynumber);
ALTER TABLE candidates ADD INDEX (political_party);
ALTER TABLE votes ADD COLUMN count int(4) NOT NULL;