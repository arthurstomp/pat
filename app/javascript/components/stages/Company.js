import React from "react"
import PropTypes from "prop-types"
import types from "../prop_types"
import { connectToUser, connectToCompanies } from "../connectors"
import ReportTable from '../shared/ReportTable'
import DepartmentsTable from '../shared/DepartmentsTable'
import request from "superagent"

class Company extends React.Component {
  componentDidMount() {
    const company_id = this.props.match.params.id
    const company = this.props.companies[company_id]
    if(company == undefined) {
      this.requestCompany(company_id)
    }
  }

  render () {
    const company_id = this.props.match.params.id
    const company = this.props.companies[company_id]
    return (
      <React.Fragment>
        {company && <h1>{company.name}</h1>}
        <h2>Report</h2>
        <ReportTable company_id={company_id}/>
        <h2>Departments</h2>
        <DepartmentsTable company_id={company_id}/>
      </React.Fragment>
    );
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
    }
  }
}

Company.propTypes = {
}

var conn_comp = connectToUser(Company)
conn_comp = connectToCompanies(conn_comp)

export default connectToCompanies(conn_comp)
