## CCR Web

### Requirements

* PostgreSQL
* Rails 4.1.0
* Ruby 2.1.0


### Install requirements

If you have RVM installed, it'll automatically download the Ruby version
you need and create a gemset for the project.

Navigate to your project folder in terminal and run a bundle install.

    bundle install

### Database config

You need to add a database config

config/database.yml is added to the gitignore file

### Initial run


On initial run, you need to run:

    rake db:create
    rake db:migrate
    rake db:seed

#### Add sample data

    rake db:sample_data

Visit the main landing page:

    http://localhost:3000/


### Running tests

First migrate and seed your database in test environment:

    RAILS_ENV=test rake db:migrate && RAILS_ENV=test rake db:seed

Sample data is not required for running tests.

rake - will run the limited rspec tests.

### Git branching etc.

master branch will be deployed to production server.

develop branch will progress and deployed to development server. Once changes are good according product owner develop will be merged into master and deployed to production server.

### Concepts  

FUNDER - Sources of funding
FUNDING CYCLES -
USER - A user of the web app, standard user and admin users
PROVIDER -  a provider of child care services
FAMILY
CHILD

EAV - ENROLLMENT/ATTENDANCE VERIFICATION FORM, a form printed for providers to track assistance of their children, this track is in paper for now.

# Development conventions

Not a straitjacket, nor the final truth, just an attempt to write guidelines that might help us maintain application:

1. When adding data that should be configurable, add it to db/seeds.rb, in ChilcareResource class.
1. Configuration values are saved as String, value might need to be parsed.
