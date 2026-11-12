CREATE TEMP TABLE temp_test (
    id INTEGER,
    name TEXT
);

INSERT INTO temp_test (id, name)
VALUES
    (1, 'Alice'),
    (2, 'Bob');

SELECT *
FROM temp_test;