import React from "react"
import PropTypes from "prop-types"
import CompaniesTable from "../shared/CompaniesTable";

import { Form, Button, Col } from "react-bootstrap"
import request from "superagent"
import {
  connectToUser,
  connectToErrors,
  connectToCompanies,
} from "../connectors"

class Companies extends React.Component {
  constructor(props) {
    super(props)
    this.state = {name: ""}
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
    this.createCompany = this.createCompany.bind(this)
    this.handleChanges = this.handleChanges.bind(this)
    this.companies_table = React.createRef();
    return (
      <React.Fragment>
        <h1>Create Company</h1>
        <Form>
          <Form.Row>
            <Col>
              <Form.Control
                name="name"
                onChange={this.handleChanges}
                placeholder="Name"/>
            </Col>
            <Col>
              <Button onClick={this.createCompany}>
                Create
              </Button>
            </Col>
          </Form.Row>
        </Form>
        <CompaniesTable ref={this.companies_table}/>
      </React.Fragment>
    );
  }

  createCompany(e) {
    e.preventDefault()
    this.handleResponse = this.handleResponse.bind(this)
    request.post("/companies")
      .set("Content-Type", "application/json")
      .set("Authorization", "Bearer: "+this.props.user.jwt)
      .send({company: {name: this.state.name}})
      .end(this.handleResponse)
  }


  handleResponse(err,res) {
    if(!err) {
      this.props.pushCompany(res.body.company)
    } else {
      this.props.setErrors(res.body)
    }
  }
}

var conn_comp = connectToUser(Companies)
conn_comp = connectToCompanies(conn_comp)
conn_comp = connectToErrors(conn_comp)

export default conn_comp
