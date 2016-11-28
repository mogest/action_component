# ActionComponent

A React-style component system for Ruby on Rails.

As your application gets bigger, you'll find you have components which are common to multiple pages.
The normal Rails way is to use a `render :partial`, but you might have some logic and/or database
setup you want to do for this partial.  Short of putting them in every controller that uses the
component, or even worse, putting them in the view, there's no elegant solution.

Enter ActionComponent.  Encapsulate a component's setup logic and view in the same class, and
render the view either from an existing Rails view, or straight from the controller.

While you can use Rails views to render your component's HTML, you can also use the JSX-like language
directly in your component's Ruby code.

## Installation

Add `gem "action_component"` to your Gemfile and run `bundle`.  Done.

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

## More documentation to come

ActionComponent is new.  It works just fine, but at the moment if you need more information than is given above,
please dive into the (very small) codebase to learn more.

## Contributing

Pull requests welcome!  If you're thinking of contributing a new feature, or
significantly changing an existing feature, please propose it as an issue.

## Licence

MIT.  Copyright Roger Nesbitt.
