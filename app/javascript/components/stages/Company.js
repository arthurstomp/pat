import React from "react"
import PropTypes from "prop-types"
import types from "../prop_types"
import { 
  connectToUser,
  connectToErrors,
  connectToCompanies } from "../connectors"
import ReportTable from '../shared/ReportTable'
import DepartmentsTable from '../shared/DepartmentsTable'
import request from "superagent"
import { withRouter } from "react-router-dom"
import { Button, Form, Col } from "react-bootstrap"

class Company extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      name: null,
      company: null
    }
  }
  componentDidMount() {
  }

	handleChanges(e) {
		const target = e.target
		const value = target.value
		const name = target.name

		this.setState({
			[name]: value
		})
	}

  render () {
    const company_id = this.props.match.params.id
    const companies = this.props.companies
    const company = this.state.company
    if(!company) {
      this.requestCompany(company_id)
    }
    this.createDepartment = this.createDepartment.bind(this)
    this.handleChanges = this.handleChanges.bind(this)
    return (
      <React.Fragment>
        {company && <h1>{company.name}</h1>}
        <Button onClick={() => {this.props.history.push("/job")}}>Create job</Button>
        <h2>Report</h2>
        <ReportTable company_id={company_id}/>
        <h2>Departments</h2>
        <Form>
          <Form.Row>
            <Col>
              <Form.Control name="name"
                onChange={this.handleChanges}
                placeholder="Name New Department"/>
            </Col>
            <Col>
              <Button onClick={this.createDepartment}>
                Create department
              </Button>
            </Col>
          </Form.Row>
        </Form>
        <DepartmentsTable company_id={company_id}/>
      </React.Fragment>
    );
  }

  createDepartment(e) {
    e.preventDefault()
    const company_id = this.props.match.params.id
    request.post("/companies/"+company_id+"/departments")
      .set("Content-Type", "application/json")
      .set("Authorization", "Bearer: "+this.props.user.jwt)
      .send({name: this.state.name, company_id: company_id})
      .end(this.handleCreatedDepartment)
  }

  handleCreatedDepartment(err, res) {
    if(err) {
      this.props.setErrors(res.body)
    }
    window.location.reload()
  }

  requestCompany(id) {
    this.handleResponse = this.handleResponse.bind(this)
    request.get("/companies/"+id)
      .set("Content-Type", "application/json")
      .set("Authorization", "Bearer: "+this.props.user.jwt)
      .end(this.handleResponse)
  }

  handleResponse(err, res) {
    if(res.status == 200) {
      this.props.pushCompany(res.body.company)
      const company = JSON.parse(res.body.company)
      this.setState({company})
    }
  }
}

Company.propTypes = {
}

var conn_comp = connectToUser(withRouter(Company))
conn_comp = connectToCompanies(conn_comp)
conn_comp = connectToErrors(conn_comp)

export default connectToCompanies(conn_comp)
