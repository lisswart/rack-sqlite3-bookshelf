class Application

  def call(env)
    res = Rack::Response.new
    req = Rack::Request.new(env)

    # BOOK routes
    if req.path == '/books' && req.get?
      books = Book.all
      return [
        200,
        { 'Content-Type' => 'application/json' },
        [ books.to_json ]
      ]

    elsif req.path.match(/add-book/) && req.post?
      body = JSON.parse(req.body.read)
      book = Book.create(body)
      return [
        200,
        { 'Content-Type' => 'application/json' },
        [ book.to_json ]
      ]

    elsif req.path.match(/books/) && req.delete?
      id = req.path.split('/')[2]      
      begin
        book = Book.find(id)
        book.destroy
        return [
          200,
          { 'Content-Type' => 'application/json' },
          [ { :message => "book destroyed" }.to_json ]
        ]
      rescue
        return [
          200,
          { 'Content-Type' => 'application/json' },
          [ { :message => "Book not found" }.to_json ]
        ]
      end

    elsif req.path.match(/books/) && req.put?
      id = req.path.split('/')[2]
      body = JSON.parse(req.body.read)
      pp body
      begin
        book = Book.find(id)
        book.update(body)
        return [
          200,
          { 'Content-Type' => 'application/json' },
          [ book.to_json ]
        ]
      rescue
        return [
          404,
          { 'Content-Type' => 'application/json' },
          [ { :message => "Book not found" } ]
        ]
      end

    elsif req.path.match(/booktags/) && req.get?
      id = req.path.split('/')[2]
      begin
        book = Book.find(id)
        # tags = book.tags
        # book_tags = {
        #   id: book.id,
        #   title: book.book_title,
        #   author: book.book_author,
        #   tags: tags
        # }
        book_tags = book.as_json(include: :tags)
        return [
          200,
          { 'Content-Type' => 'application/json' },
          [ book_tags.to_json ]
        ]
      rescue
        return [
          200,
          { 'Content-Type' => 'application/json' },
          [ { :message => "Book not found" }.to_json ]
        ]
      end
    elsif req.path.match(/booktags/) && req.put?
      id = req.path.split('/').last
      begin
        book = Book.find(id)
        pp book
        pp book.book_title
        pp book.book_author
        pp req.body        
        body = JSON.parse(req.body.read)
        pp body
        return [
          200,
          { 'Content-Type' => 'application/json' },
          [ book.to_json ]
        ]
      rescue
        return [
          404,
          { 'Content-Type' => 'application/json' },
          [ {:message => "Book not found"} ]
        ]
      end
    elsif req.path.match(/bookstatus/) && req.get?
      id = req.path.split('/').last
      begin
        book = Book.find(id)
        status_id = book.status_id
        status = Status.find(status_id)
        return [
          200,
          { 'Content-Type' => 'application/json' },
          [status.to_json]
        ]
      rescue
        return [
          404,
          { 'Content-Type' => 'application/json' },
          [ { :message => "read status not found" }.to_json ]
        ]
      end

    # TAG routes
    elsif req.path == '/tags' && req.get?
      tags = Tag.all
      return [
        200,
        { 'Content-Type' => 'application/json' },
        [ tags.to_json ]
      ]

    elsif req.path.match(/tags/) && req.get?
      id = req.path.split('/').last
      begin
        tag = Tag.find(id)
        tag_books = tag.as_json(include: :books)
        return [
          200,
          { 'Content-Type' => 'application/json' },
          [ tag_books.to_json ]
        ]
      rescue
        return [
          404,
          { 'Content-Type' => 'application/json' },
          [ { :message => "Tag not found" } ]
        ]
      end

    elsif req.path.match(/add_tag/) && req.post?
      body = JSON.parse(req.body.read)
      tag = Tag.create(body)
      return [
        200,
        { 'Content-Type' => 'application/json' },
        [ tag.to_json ]
      ]

    elsif req.path.match(/tags/) && req.put?
      id = req.path.split('/')[2]
      body = JSON.parse(req.body.read)
      begin
        tag = Tag.find(id)
        tag.update(body)
        return [
          200,
          { 'Content-Type' => 'application/json' },
          [ tag.to_json]
        ]
      rescue
        return [
          404,
          { 'Content-Type' => 'application/json' },
          [ { :message => "Tag not found" }.to_json ]
        ]
      end
    elsif req.path.match(/tags/) && req.delete?
      id = req.path.split('/')[2]
      begin
        tag = Tag.find(id)
        tag.destroy
        return [
          200,
          { 'Content-Type' => 'application/json' },
          []
        ]
      rescue
        return [
          404,
          { 'Content-Type' => 'application/json' },
          [ { :message => "Tag not found" } ]
        ]
      end

    # STATUS routes
    elsif req.path == '/statuses' && req.get?
      statuses = Status.all
      return [
        200,
        { 'Content-Type' => 'application/json' },
        [ statuses.to_json ]
      ]

    elsif req.path.match(/statuses/) && req.get?
      id = req.path.split('/')[2]
      begin
        status = Status.find(id)
        status_books = status.as_json(include: :books)
        return [
          200,
          { 'Content-Type' => 'application/json' },
          [ status_books.to_json ]
        ]
      rescue
        return [
          200,
          { 'Content-Type' => 'application/json' },
          [ { :message => "Status not found" } ]
        ]
      end
    elsif req.path.match(/add_status/) && req.post?
      body = JSON.parse(req.body.read)
      status = Status.create(body)
      return [
        200,
        { 'Content-Type' => 'application/json' },
        [ status.to_json ]
      ]
    elsif req.path.match(/statuses/) && req.put?
      id = req.path.split('/')[2]
      body = JSON.parse(req.body.read)
      begin
        status = Status.find(id)
        status.update(body)
        return [
          200,
          { 'Content-Type' => 'application/json' },
          [ status.to_json ]
        ]
      rescue
        return [
          404,
          { 'Content-Type' => 'application/json' },
          [ { :message => "Status not found" } ]
        ]
      end

    elsif req.path.match(/statuses/) && req.delete?
      id = req.path.split('/')[2]
      begin
        status = Status.find(id)
        status.destroy
        return [
          200,
          { 'Content-Type' => 'application/json' },
          []
        ]        
      rescue
        return [
          404,
          { 'Content-Type' => 'application/json' },
          [ { :message => "Status not found" } ]
        ]
      end

    # GROUP routes
    elsif req.path == '/groups' && req.get?
      groups = Group.all
      return [
        200,
        { 'Content-Type' => 'application/json' },
        [ groups.to_json ]
      ]
    elsif req.path.match(/groups/) && req.get?
      id = req.path.split('/').last
      begin
        group = Group.find(id)
        group_books = group.as_json(include: :books)
        return [
          200,
          { 'Content-Type' => 'application/json' },
          [ group_books.to_json ]
        ]
      rescue
        return [
          404,
          { 'Content-Type' => 'application/json' },
          [ { :message => "group not found" } ]
        ]
      end
    elsif req.path.match(/groups/) && req.post?
      body = JSON.parse(req.body.read)
      group = Group.create(body)
      return [
        200,
        { 'Content-Type' => 'application/json' },
        [ group.to_json ]
      ]
 
    else
      res.write "Path Not Found"
    end

    res.finish
  end

end