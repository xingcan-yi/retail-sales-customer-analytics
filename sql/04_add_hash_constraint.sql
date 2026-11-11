ALTER TABLE raw.import_batches
ADD CONSTRAINT chk_file_hash_sha256
CHECK (file_hash ~ '^[0-9a-f]{64}$');