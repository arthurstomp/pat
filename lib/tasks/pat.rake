namespace :pat do
  desc "Seed report data"
  task seed_report: :environment do 
    user = User.last
    puts "Using user"
    pp user
    puts "Creating user's company"
    company = FactoryBot.create(:company, user: user)
    pp company
    puts "Creating departments for company #{company.name}"
    d1 = FactoryBot.create :department, company: company
    d2 = FactoryBot.create :department, company: company
    d3 = FactoryBot.create :department, company: company
    deps = [d1,d2,d3]
    puts "Creating employees"
    n_employees = ARGV.last.to_i
    user_ns = Array.new(n_employees) { Random.rand(1_000..2_000) }
    user_ns = user_ns.uniq
    n_employees.times do
      rand_dep_index = Random.rand(0..deps.length - 1)
      d = deps[rand_dep_index]
      un = user_ns.pop
      u = FactoryBot.create :user, username: "user#{un}", email: "user#{un}@test.com"
      employee = FactoryBot.build :employee, company: company, department: d, user: u
      if employee.valid?
        employee.save
        print "."
      else
        print "F"
      end
    end

    task n_employees.to_s.to_sym do ; end
  end
end
