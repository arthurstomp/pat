def log_persisted(m)
  if m.persisted?
    logger.info "Created #{m}"
  else
    logger.error m.errors.messages
    raise "Error on seeding #{m}"
  end
end

company_a = Company.create(name: "Company A")
log_persisted(company_a)

company_B = Company.create(name: "Company B")
log_persisted(company_b)

admin_a = CreateUserAndEmployeeService.execute(
  email: "admin_a@company_a.com",
  username: "admin_a",
  name: "Admin A",
  company: company_a,
  role: "administrator"
)
log_persisted(admin_a)

admin_b = CreateUserAndEmployeeService.execute(
  email: "admin_b@company_b.com",
  username: "admin_b",
  name: "Admin B",
  company: company_b,
  role: "administrator"
)
log_persisted(admin_b)

employee_a1 = CreateUserAndEmployeeService.execute(
  email: "admin_a@company_a.com",
  username: "admin_a",
  name: "Admin A",
  company: company_a,
  role: "administrator"
)

