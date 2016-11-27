# ActionComponent

A React-style component system for Ruby on Rails.

This gem should be considered "alpha" as it currently has no tests.

## Examples

### Example 1: Integrating components into a standard Rails app

```html+erb
<!-- app/views/posts/show.html.erb -->

<div class="post">
  <h2><%= @post.title %></h2>
  <%= render_component AuthorComponent, author: @post.author %>

  <%= simple_format @post.content %>
</div>
```

```ruby
# app/components/author_component.rb

class AuthorComponent < ActionComponent::Base
  def load
    @post_count = @author.posts.published.count
  end

  def view
    div(class: 'author') do
      insert image_tag(@author, alt: @author.name)

      div link_to(@author.name, @author), class: 'name'

      div pluralize(@post_count, 'post'), class: 'post-count'

      stars
    end
  end

  def stars
    div class: 'stars' do
      @author.stars.times { span "*" }
    end
  end
end
```

### Example 2: Using components instead of views

```ruby
# app/controllers/posts_controller.rb

class PostsController < ApplicationController
  def show
    post = Post.find(params[:id])

    render_component PostComponent, post: post
  end
end
```

```ruby
# app/components/post_component.rb

class PostComponent < ActionComponent::Base
  # You can specify which variables must be passed to this component and their
  # types (but only if you want to; by default it accepts everything.)
  required post: Post

  def view
    div(class: 'post') do
      h2 @post.title

      component AuthorComponent, author: @post.author

      insert simple_format(@post.content)
    end
  end
end
```

## Contributing

Pull requests welcome!  If you're thinking of contributing a new feature, or
significantly changing an existing feature, please propose it as an issue.

## Licence

MIT.  Copyright Roger Nesbitt.
