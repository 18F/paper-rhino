class SearchesController < ApplicationController
  def show
    @term = params[:q]

    q = @term.
      to_s.                       # 1. typecase into a string
      strip.                      # 2. remove leading and tailing whitespace
      downcase.                   # 3. make all lowercase
      gsub(/[^[:alnum:]\s]/, ''). # 4. remove all non-alphanumberic and non-space characters
      gsub(/\s+/, ' ').           # 5. replace multiple spaces with just one space
      gsub(/[\s]/, ':* & ').      # 6. convert spaces into prefix matchers
      gsub(/$/, ':*')

    safe_q = ActiveRecord::Base.connection.quote(q)

    query = <<-SQL
      select
        d.id as id,
        d.attachment_name as name,
        ts_rank(d.attachment_tsterms, tsquery) as search_rank,
        ts_headline('pg_catalog.english', d.attachment_name, tsquery) as headlined_name,
        ts_headline('pg_catalog.english', array_to_string(d.attachment_pages, ' ', ''), tsquery, 'MinWords=100,MaxWords=101') as headlined_pages
      from documents d, to_tsquery('pg_catalog.english', '#{q}') as tsquery
      where attachment_tsterms @@ tsquery
      order by search_rank desc;
    SQL

    @results = ActiveRecord::Base.connection.select_all(query)
  end

  def new
    @term = nil
  end

  def create
    @document = Document.new(params.require(:document).permit(:attachment))

    if @document.save
      render text: "Great!"
    else
      render text: "Oh No!"
    end
  end
end
