import React from "react"
import PropTypes from "prop-types"

import types from "../prop_types"
import { Table, Button } from "react-bootstrap"
import { 
  connectToCompanies,
  connectToUser
} from "../connectors"
import { Link } from "react-router-dom"
import request from "superagent"
import { connect  } from 'react-redux'

class CompaniesTable extends React.Component {
  componentDidMount() {
    this.requestCompanies({
      relationship: this.props.relationship_to_company,
      traits: this.props.traits
    })
  }

  render () {
    const companies = Object.values(this.props.companies)
    const hasTrait = this.hasTrait.bind(this)
    const renderNameOrLink = this.renderNameOrLink
    self = this
    return (
      <React.Fragment>
        <h2>Companies</h2>
        <Table striped>
          <thead>
            <tr>
              <td>Name</td>
              {hasTrait("number_of_departments") &&
                <td>Nº Departments</td>}
              {hasTrait("number_of_employees") &&
                <td>Nº Employees</td>}
              <td>Owner</td>
              <td>Admin</td>
              <td></td>
            </tr>
          </thead>
          <tbody>
            {companies.length != 0 &&
                companies.map(function(c){
                  if(c) {
                    return(
                      <tr key={"company_"+c.id}>
                        {renderNameOrLink(c)}
                        {hasTrait("number_of_departments") &&
                          <td>{c.number_of_departments}</td>}
                        {hasTrait("number_of_employees") &&
                          <td>{c.number_of_employees}</td>}
                        <td>{c.admin ? "true" : "false"}</td>
                        <td>{c.owner ? "true" : "false"}</td>
                        <td>{false && c.owner && 
                          <Button 
                            onClick={self.createDeleteCompany(c.id)}
                            variant="danger">Delete</Button>}
                        </td>
                      </tr>
                    )
                  } else {
                    return null
                  }
            })}
          </tbody>
        </Table>
      </React.Fragment>
    );
  }

  renderNameOrLink(c) {
    if(c.admin){
      return(<td><Link to={"/company/"+c.id}>{ c.name }</Link></td>)
    } else {
      return(<td>{c.name}</td>)
    }
  }

  hasTrait(trait) {
    if(this.props.traits.includes(trait)) {
      return true
    } else {
      return false
    }
  }

  requestCompanies(req) {
    this.handleResponse = this.handleResponse.bind(this)
    request.get("/companies")
      .set("Content-Type", "application/json")
      .set("Authorization", "Bearer: "+this.props.user.jwt)
      .query({
        relationship_to_company: this.props.relationship_to_company,
        number_of_employees: this.props.traits.includes("number_of_employees") && true,
        number_of_departments: this.props.traits.includes("number_of_departments") && true
      })
      .end(this.handleResponse)
  }

  handleResponse(err, res) {
    if(res.status == 200) {
      this.props.setCompanies(res.body.companies)
      this.forceUpdate()
    }
  }

  createDeleteCompany(id) {
    const self = this
    return (e) => {
      e.preventDefault()
      //request.delete("/companies/"+id)
        //.set("Content-Type", "application/json")
        //.set("Authorization", "Bearer: "+self.props.user.jwt)
        //.end(function() {
          ////self.props.deleteCompany(id)
          ////this.forceUpdate()
        //})
    }
  }
}

CompaniesTable.defaultProps = {
  companies: {},
  relationship_to_company: "member",
  //traits: []
  traits: ["number_of_employees", "number_of_departments"]
}

CompaniesTable.propTypes = {
  companies: PropTypes.shape()
}

var conn_comp = connectToCompanies(CompaniesTable)
conn_comp = connectToUser(conn_comp)

const mapStateToProps = state => ({
  companies: state.companies
})

export default connect(mapStateToProps)(conn_comp)
