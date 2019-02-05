# README

Simple user management system.

* Ruby version

  `2.5.3p`

* System dependencies
  * NodeJS
  * PosgreSQL Database

* Configuration

  Create your own vesion of ``.env`` based on dotenv_sample.

* Database creation

  `$ bundle exec rails db:create`

* Database initialization

  `$ bundle exec rails db:setup`

* How to run the test suite

  ``$ rails assets:precompile``
  `$ bundle exec rspec spec`

## Authentication

This system has weak authentication by design.

Choose an unused email and username to create your account on the login form.

Once an account is created the user can be assigned to a job at any company
and department of the system.

## Policies

### Admin

Admins can be both the owner of the company or and admin employee of that company.

Admins can alter company, create departements and adding employees.

Admins have access to a report of employees with biggest salary.

### Employee

Employees can only access and alter their own information.

