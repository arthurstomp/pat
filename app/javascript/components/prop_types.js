import PropTypes from "prop-types";

const user_shape = PropTypes.shape({
  email: PropTypes.string,
  username: PropTypes.string,
})

const job_shape = PropTypes.shape({
  company: PropTypes.string,
  role: PropTypes.string,
  department: PropTypes.string,
  salary: PropTypes.float
})

const department_shape = PropTypes.shape({
  company: PropTypes.string,
  name: PropTypes.string,
  n_employees: PropTypes.integer
})

const company_shape = PropTypes.shape({
  name: PropTypes.string,
  n_departments: PropTypes.integer,
  n_employees: PropTypes.integer,
})

export default {
  user_shape,
  job_shape,
  company_shape,
  department_shape
}

