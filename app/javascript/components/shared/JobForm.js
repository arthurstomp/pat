import React from "react"
import PropTypes from "prop-types"
import { Form, Button } from "react-bootstrap"
import request from "superagent"
import { connect  } from 'react-redux'
import {
  connectToUser,
  connectToErrors
} from "../connectors"
import { Alert } from "react-bootstrap"
import _ from "lodash"

class JobForm extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      job: props.job,
      users: [],
      companies: [],
      departments: [],
      can_update: props.create,
      selectedUser: {},
      selected_company: {},
      selected_department: {},
      selected_role: "employee",
      success: false
    }
  }

  shouldFetchJob() {
    if(this.state.job == null &&
      this.props.id) {
      this.fetchJob()
    }
  }

  shouldFetchCompanies() {
    if(this.state.companies.length == 0) {
      this.fetchCompanies()
    }
  }

  shouldFetchUsers() {
    if(this.props.create && this.state.users.length == 0) {
      this.fetchUsers()
    }
  }

  render() {
    this.shouldFetchJob()
    this.shouldFetchCompanies()
    this.shouldFetchUsers()
    if(this.state.job) {
      return this.renderForm()
    }
    return null
  }

  handleChanges(e) {
		const target = e.target
		const value = target.value
		const name = target.id
    var state = this.state
    switch(name) {
      case "user":
        state =this.setUserState(state, name, value)
        break
      case "department":
        state = this.setDepartmentState(state, name, value)
        break
      case "company":
        state = this.setCompanyState(state, name, value)
        break
      case "salary":
        state = Object.assign(state, {salary: value})
        break
      case "role":
        state = Object.assign(state, {selected_role: value})
        break
      default:
        state
    }
    debugger
    this.setState(Object.assign(this.state,state))
    //this.forceUpdate()
  }

  setCompanyState(state, name, value) {
    if(name == "company") {
      const selected_company = this.mergedCompanies().filter((c)=> {return c.id == parseInt(value)})[0]
      const departments = selected_company.departments
      const new_state = Object.assign(state, {
        selected_company: selected_company,
        selected_department: selected_company.departments[0],
        departments: selected_company.departments
      })
      return new_state
    }
    return state
  }

  setDepartmentState(state, name, value) {
    if(name == "department") {
      const selected_department = this.state.departments.filter((d)=> {return d.id == parseInt(value)})[0]
      return Object.assign(state, {
        selected_department: selected_department
      })
    }
  }

  setUserState(state, name, value) {
    if(name == "user") {
      const selected_user = this.state.users.filter((u) => {return u.id == parseInt(value)})[0]
      return Object.assign(state, {
        selected_user: selected_user
      })
    }
  }

  handleResponse(err,res) {
    if(res.status == 200) {
      this.setState({success: true})
    }
  }

  resetSuccess() {
    this.setState({success: false})
  }

  renderForm() {
    debugger
    const self = this
    const companies = this.mergedCompanies()
    const departments = this.state.selected_company.departments ? this.state.selected_company.departments : []
    this.handleChanges = this.handleChanges.bind(this)
    this.resetSuccess = this.resetSuccess.bind(this)
    this.handleResponse = this.handleResponse.bind(this)
    if(this.state.success) {
      setTimeout(this.resetSuccess, 2000)
    }
    return (
      <React.Fragment>
        <Alert
          show={this.state.success}
          variant="success"
          onClose={this.resetSuccess}>
          Job updated.
        </Alert>
        <Form>
          {this.renderUsername()}

          <Form.Group controlId="role">
            <Form.Label>Role</Form.Label>
            <Form.Control as="select"
              disabled={!this.state.can_update}
              defaultValue={this.state.job.role}
              onChange={this.handleChanges}>
              {["administrator", "employee"].map(function(r) {
                return(
                  <option 
                    key={"role_"+r}
                    value={r}>
                    {r}
                  </option>
                )
              })}
            </Form.Control>
          </Form.Group>

          <Form.Group controlId="company">
            <Form.Label>Company</Form.Label>
            <Form.Control as="select"
              disabled={!this.state.can_update}
              defaultValue={this.selected_company ? this.selected_company.id : null}
              onChange={this.handleChanges}>
              {companies.length != 0 &&
                companies.map(function(c) {
                  return(
                    <option key={"company_"+c.id} value={c.id}>
                      {c.name}
                    </option>
                  )
              })}
            </Form.Control>
          </Form.Group>

          <Form.Group controlId="department">
            <Form.Label>Department</Form.Label>
            <Form.Control as="select"
              disabled={!this.state.can_update}
              defaultValue={this.selected_department ? this.selected_department.id : null}
              onChange={this.handleChanges}>
              {departments.length != 0 &&
                departments.map(function(d) {
                  return(
                    <option
                      key={"department_"+d.id}
                      value={d.id}>
                      {d.name}
                    </option>
                  )
              })}
            </Form.Control>
          </Form.Group>

          <Form.Group controlId="salary">
            <Form.Label>Salary</Form.Label>
            <Form.Control 
              type="text"
              disabled={!this.state.can_update}
              defaultValue={this.state.job.salary}
              onChange={this.handleChanges}/>
          </Form.Group>

          <Button 
            disabled={!this.state.can_update} 
            onClick={this.submitAction()}
            variant="primary" 
            type="submit">
            { this.props.id ? "Update" : "Create" }
          </Button>
        </Form>
      </React.Fragment>
    )
  }

  renderUsername() {
    if(this.props.create) {
      return this.renderUsernameForm()
    } else {
      return (
        <Form.Group controlId="user">
          <Form.Label>Username</Form.Label>
          <Form.Control 
            type="text"
            disabled={!this.props.create}
            defaultValue={this.state.job.name}
            onChange={this.handleChanges}/>
        </Form.Group>
      )
    }
  }
  renderUsernameForm() {
    const users = this.state.users
    return(
      <Form.Group controlId="user">
        <Form.Label>Department</Form.Label>
        <Form.Control as="select"
          disabled={!this.state.can_update}
          defaultValue={this.selected_user_id ? this.selected_user_id : null}
          onChange={this.handleChanges}>
          {users.length != 0 &&
            users.map(function(u) {
              return(
                <option
                  key={"user_"+u.id}
                  value={u.id}>
                  {u.username} - {u.email}
                </option>
              )
            })}
        </Form.Control>
      </Form.Group>
    )
  }

  mergedCompanies() {
    var merged;
    if(this.state.job) {
      if(this.state.job.company) {
        merged = [this.state.job.company ].concat(this.state.companies)
      }else {
        merged = this.state.companies
      }
      merged = _.uniqBy(merged, function(e) { return e.id })
      return merged
    } else {
      return this.state.companies
    }
  }

  mergedDepartments() {
    return this.state.departments
  }

  submitAction() {
    this.updateJobState = this.updateJobState.bind(this)
    if(this.props.id) {
      this.updateJob = this.updateJob.bind(this)
      return this.updateJob
    } else {
      this.createJob = this.createJob.bind(this)
      return this.createJob
    }
  }

  createJob(e) {
    e.preventDefault()
    request.post("/jobs/")
      .set("Content-Type", "application/json")
      .set("Authorization", "Bearer: "+this.props.user.jwt)
      .send({job: {
        user_id: this.state.selected_user.id ? this.state.selected_user.id : null,
        company_id: this.state.selected_company.id ? this.state.selected_company.id : null,
        department_id: this.state.selected_department.id ? this.state.selected_department.id : null,
        salary: this.state.salary,
        role: this.state.selected_role
      }})
      .end(this.updateJobState)
  }

  updateJob(e) {
    e.preventDefault()
    request.put("/jobs/"+this.state.job.id)
      .set("Content-Type", "application/json")
      .set("Authorization", "Bearer: "+this.props.user.jwt)
      .send({job: {
        company_id: this.state.selected_company.id,
        department_id: this.state.selected_department.id,
        salary: parseFloat(this.state.salary),
        role: this.state.selected_role.toLocaleLowerCase()
      }}).end(this.updateJobState)
  }

  updateJobState(err, res) {
    if(res.status == 200) {
      const job = JSON.parse(res.body.job)
      const can_update = JSON.parse(res.body.can_update)
      var company = {}
      var department = {}
      if(job) {
        company = job.company
        department = job.department
      }
      this.setState({job: job,
        can_update: can_update,
        salary: job.salary.toString(),
        selected_company: company,
        selected_department: department,
        success: res.req.method == "PUT" || res.req.method == "POST"})
    } else {
      this.props.setErrors(res.body.errors)
    }
    this.props.onUpdateJobState(err,res)
  }

  fetchJob() {
    const self = this
    this.updateJobState = this.updateJobState.bind(this)
    request.get("/jobs/"+this.props.id)
      .set("Content-Type", "application/json")
      .set("Authorization", "Bearer: "+this.props.user.jwt)
      .end(this.updateJobState)
  }

  fetchCompanies() {
    const self = this
    request.get("/companies/")
      .set("Content-Type", "application/json")
      .set("Authorization", "Bearer: "+this.props.user.jwt)
      .query({relationship_to_company: "admin"})
      .end(function(err, res){
        self.setDepartments = self.setDepartments.bind(self)
        const companies = JSON.parse(res.body.companies)
        self.setDepartments(companies)
        const state = self.state
        var newState = Object.assign(state, {companies: companies})
        if(!newState.selected_company) {
          newState = Object.assign(newState, {selected_company: companies[0]})
        }
        self.setState({companies: companies, selected_company: companies[0]})
      })
  }

  fetchUsers() {
    const self = this
    request.get("/users")
      .set("Content-Type", "application/json")
      .set("Authorization", "Bearer: "+this.props.user.jwt)
      .end(function(err,res) {
        const users = JSON.parse(res.body.users)
        self.setState({users: users, selected_user: users[0]})
      })
  }

  setDepartments(companies) {
    const ds = companies.map(function(c) { 
      return c.departments
    }).flat()

    this.setState({departments: ds})
  }
}

JobForm.defaultProps = {
  route: "/",
  submitBtn: "Create",
  onUpdateJobState: function(errors) {}
}

JobForm.propTypes = {
  route: PropTypes.string,
  submitBtn: PropTypes.string,
  onUpdateJobState: PropTypes.func
}

var conn_comp = connectToErrors(JobForm)
conn_comp = connectToUser(conn_comp)

export default conn_comp
