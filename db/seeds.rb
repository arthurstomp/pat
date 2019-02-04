def log_persisted(m)
  if m.persisted?
    logger.info "Created #{m}"
  else
    logger.error m.errors.messages
    raise "Error on seeding #{m}"
  end
end

def create_companies(user, other_user)
  c1 = FactoryBot.create(:company, user: user)
  admin = c1.departments.create name: "Admin"
  sales = c1.departments.create name: "Sales"

  c1.employees.create user: user, department: admin, role: "administrator", salary: 5000
  c1.employees.create user: FactoryBot.create(:user), department: sales, role: "employee", salary: 400

  c2 = FactoryBot.create(:company, user: user)
  admin = c2.departments.create name: "Admin"
  sales = c2.departments.create name: "Sales"

  c2.employees.create user: user, department: admin, role: "administrator", salary: 4000
  c2.employees.create user: other_user, department: sales, role: "administrator", salary: 3870
  [c1,c2]
end


user_1 = FactoryBot.create(:user)
user_2 = FactoryBot.create(:user)

companies1 = create_companies(user_1, user_2)
companies2 = create_companies(user_2, user_1)

company_1A = FactoryBot.create(:company, user: user_1)
company_1A = FactoryBot.create(:company, user: user_1)
company_2A = FactoryBot.create(:company, user: user_2)



