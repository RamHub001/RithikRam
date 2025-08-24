---
title: "10 Best Practices for Writing Clean and Maintainable Ruby on Rails Code"
date: 2025-08-24
---

As a seasoned Ruby on Rails developer, I've spent countless hours wrestling with codebases of all shapes and sizes—from speedy MVPs to sprawling, mission-critical platforms. Through trial, error, and many late-night code reviews, these best practices have become my go-to strategies for keeping Rails projects clean, maintainable, and scalable.

Below, I have shared ten actionable tips, each supported by real-world experience, technical details, and examples. If you're looking to level up your Rails craft, this is your blueprint.

1. Embrace Service Objects for Business Logic
Early on, I learned that cramming business logic into controllers or models quickly turns into a mess. Service objects allow you to isolate complex operations:

'''ruby
# Poor: Complex logic in controller
def create
  @order = Order.new(order_params)
  if @order.save
    PaymentGateway.charge(@order.amount)
    Mailer.order_confirmation(@order)
    # ...more
  end
end

# Improved: Dedicated service object
class OrderProcessor
  def initialize(order)
    @order = order
  end

  def call
    PaymentGateway.charge(@order.amount)
    Mailer.order_confirmation(@order)
    # more steps
  end
end

def create
  @order = Order.new(order_params)
  if @order.save
    OrderProcessor.new(@order).call
  end
end
'''

Why? You keep controllers slim and logic reusable. Debugging and testing also get easier.

2. Use Concerns Thoughtfully
Concerns are great for code reuse—provided you don’t let them become a dumping ground. I recommend:

'''ruby
# app/models/concerns/soft_deletable.rb
module SoftDeletable
  extend ActiveSupport::Concern
  def soft_delete
    update(deleted_at: Time.current)
  end

  def deleted?
    deleted_at.present?
  end
end

class User < ApplicationRecord
  include SoftDeletable
end
'''

Pitfall: Don’t cram too much logic into concerns. If a concern grows beyond a few methods, consider refactoring into a service object or another domain class.

3. Skinny Controllers, Fat Models
I've seen controllers balloon into hundreds of lines. Best practice: keep controllers focused on request/response, and delegate business logic to models/services.

'''ruby
# Poor: Controller knows too much
def archive
  if params[:archive_type] == 'soft'
    @post.update(archived: true)
  else
    @post.destroy
  end
end

# Improved: Model handles logic
class Post < ApplicationRecord
  def archive!(type = :soft)
    type == :soft ? update(archived: true) : destroy
  end
end

def archive
  @post.archive!(params[:archive_type].to_sym)
end
'''

Why? Controllers stay readable; models become the authority for business rules.

4. Organize Code for Modularity
In larger Rails apps, code organization is everything. Use Rails’ directory conventions, but don’t be afraid to create folders for domain objects, presenters, decorators, or custom services (e.g., app/services, app/presenters).

Anecdote: On a complex IoT project, introducing app/interactors/ for orchestration logic slashed technical debt and reduced onboarding headaches.

5. Optimize for Performance (Not Just Readability)
Readable code is great, but always keep an eye on performance bottlenecks. For example:

Use database indexes for frequently-filtered columns.

Cache expensive queries or rendered views with Rails caching.

Profile code with tools like NewRelic, Bullet, or Skylight.

'''ruby
# Avoid
User.where(active: true).each { |u| u.calculate_score }

# Better
User.where(active: true).find_each(batch_size: 100) { |u| u.calculate_score }
Why? Prevents N+1 queries and memory leaks.
'''

6. Test Early, Test Often (And Write Readable Specs)
In my experience, projects with robust tests always outlive those without. Use RSpec for clarity:

'''ruby
# This test is vague
it "should save user" do
  expect(User.create(name: "A")).to be_valid
end

# Improved: Clear and robust
it "creates a user with valid attributes" do
  user = User.new(name: "Alice", email: "alice@example.com")
  expect(user).to be_valid
end
'''

Tip: Aim for high coverage of models, services, and edge cases. Use FactoryBot and fixtures as appropriate.

7. Choose Gems Carefully
It’s tempting to add gems for every new need, but tread carefully. Evaluate gems for:

Longevity and maintenance

Documentation and community support

Security risks (always run bundle audit)

Story: We replaced a popular PDF generation gem once it went stale, which saved hours of firefighting.

Guidance: If in doubt, build small features in-house or use gems with active contributors.

8. Avoid N+1 Queries
N+1 queries can devastate performance. Always preload associations:

'''ruby
# Poor: N+1 queries
@users.each { |u| puts u.posts.count }

# Improved: Preload posts
@users = User.includes(:posts)
@users.each { |u| puts u.posts.count }
Tools: Use Bullet to detect N+1s in development.
'''

9. Refactor Ruthlessly (But Safely)
Regular refactoring is crucial: split large methods, extract logic into modules or service objects, and remove dead code. Always write tests before serious refactoring.

Example:

'''ruby
# Before: Bloated method
def calculate_total
  @total = 0
  items.each do |item|
    @total += item.price * item.quantity
  end
  @total -= @total * discount_rate
  @total += shipping_fee
end

# After: Refactored
def calculate_total
  subtotal = items.sum { |item| item.price * item.quantity }
  discounted = subtotal - subtotal * discount_rate
  discounted + shipping_fee
end
'''

10. Enforce Consistent Coding Standards
Consistency improves readability and onboarding. Use RuboCop, Prettier, or custom linting tools. Hold regular code reviews focusing on:

Naming conventions

Indentation

Parameter order

Error and exception handling

Personal Note: Instituting pre-commit hooks (lint checks, spec runs) nearly eliminated merge conflicts and buggy deploys.

Final Thoughts
Maintaining clean Rails code isn’t about perfection—it’s about discipline, empathy for your fellow developers, and a relentless pursuit of clarity. Every codebase is a living thing; treat yours with respect and care. Most importantly, don’t be afraid to revisit and revise your patterns as your project and team grow.

Have you faced challenging Rails code? What best practices helped you overcome them? Share your thoughts below!
