class AddSearchToDocuments < ActiveRecord::Migration[5.0]
  def up
    execute <<-SQL.strip
      alter table documents add column attachment_name varchar;
      alter table documents add column attachment_tags varchar[];
      alter table documents add column attachment_pages varchar[];

      alter table documents add column attachment_tsterms tsvector;
      create index documents_attachment_tsterms_idx on documents USING gin(attachment_tsterms);

      create function documents_attachment_tsterms_tfun() returns trigger as $$
      begin
        new.attachment_tsterms :=
         setweight(to_tsvector('pg_catalog.english', coalesce(new.attachment_name, '')), 'A') ||
         setweight(to_tsvector('pg_catalog.english', coalesce(array_to_string(new.attachment_tags, ' ', ''), '')), 'A') ||
         setweight(to_tsvector('pg_catalog.english', coalesce(array_to_string(new.attachment_pages, ' ', ''), '')), 'B');
        return new;
      end;
      $$ language 'plpgsql';

      create trigger documents_attachment_tsterms_trig
      before insert or update
      of attachment_name, attachment_tags, attachment_pages, attachment_tsterms
      on documents for each row
      execute procedure documents_attachment_tsterms_tfun();

      update documents set attachment_tsterms = null;
    SQL

  end

  def down
    execute <<-SQL.strip
      drop trigger if exists documents_attachment_tsterms_trig on documents;
      drop function if exists documents_attachment_tsterms_tfun();
      alter table documents drop column attachment_name;
      alter table documents drop column attachment_tags;
      alter table documents drop column attachment_pages;
      alter table documents drop column attachment_tsterms;
    SQL
  end
end
