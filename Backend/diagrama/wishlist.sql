select * from user_entity;
select * from country;
select * from history;
select * from province;
select * from wishlist;
select * from chapter;
select * from reader;
select * from reader_chapter;

INSERT INTO wishlist (id_user_entity, id_history) VALUES (1, 68);

delete from reader_chapter where id = 152;
delete from reader where id = 1;
delete from wishlist where id = 24;
DROP TABLE wishlist;


SELECT * FROM wishlist WHERE user_entity_id IS NULL OR history_id IS NULL;
ALTER TABLE wishlist RENAME COLUMN user_entity_id TO user_entity;

CREATE TABLE wishlist (
    id SERIAL PRIMARY KEY,
    id_user_entity BIGINT NOT NULL,
    id_history BIGINT NOT NULL,
    CONSTRAINT fk_user FOREIGN KEY (id_user_entity) REFERENCES user_entity(id),
    CONSTRAINT fk_history FOREIGN KEY (id_history) REFERENCES history(id)
);


