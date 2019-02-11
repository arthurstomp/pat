# README

Simple user management system.

* Ruby version

  `2.5.3p`

* System dependencies
  * NodeJS
  * PosgreSQL Database

* Configuration

  Create your own vesion of `.env` based on dotenv_sample.

* Database creation

  `$ bundle exec rails db:create`

* Database initialization

  `$ bundle exec rails db:setup`

* Starting the server

  `$ bundle exec rails s`

* How to run the test suite

  `$ rails assets:precompile`
  `$ bundle exec rspec spec`

## Authentication

This system has weak authentication by design.

Choose an unused email and username to create your account on the login form.

To login with an user just use and existing username and email.

Once an account is created the user can be assigned to a job at any company
and department of the system.

### Credentials

The seeded Database has 2 seeded users: 

  * username: `user1`; email: `user1@test.com`.
  * username: `user2`; email: `user2@test.com`. 

## Seed for Report

The challenge requires to admins to be able to see a report with a table containing
all company's employees ordered by first it's department name, later by the biggest
salary.

This report can be found at `Login > Companies > Select a company > Report Table`, or
on `/companies/:company_id/report` route.

To easily get data there, the rake task can be used `rails pat:seed_report`

```
$ rails pat:seed_report
Using user
#<User:0x00007fdb7db09478
 id: 1,
 email: "user1@test.com",
 username: "user1",
 created_at: Mon, 11 Feb 2019 15:36:17 UTC +00:00,
 updated_at: Mon, 11 Feb 2019 15:36:17 UTC +00:00>
Creating user's company
#<Company:0x00007fdb7c6813e8
 id: 8,
 name: "Arryn of the Eyrie",
 created_at: Mon, 11 Feb 2019 15:36:22 UTC +00:00,
 updated_at: Mon, 11 Feb 2019 15:36:22 UTC +00:00,
 user_id: 1>
Creating departments for company Arryn of the Eyrie
Creating employees
..................................................%
```

## Policies

### Admin

Admins can be both the owner of the company or and admin employee of that company.

Admins can alter company, create departements and adding employees.

Admins have access to a report of employees with biggest salary.

### Employee

Employees can only access and alter their own information.

