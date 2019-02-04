import React from "react"
import PropTypes from "prop-types"
import types from "../prop_types"
import { Table } from "react-bootstrap"
import request from "superagent"
import { withRouter, Link } from "react-router-dom"
import { connectToUser } from "../connectors"

class DepartmentsTable extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      departments: null
    }
  }
  render () {
    if(this.state.departments === null) {
      this.requestDepartments()
    }
    const company_id = this.props.match.params.company_id
    const id = this.props.match.params.id
    return (
      <React.Fragment>
        <Table striped>
          <thead>
            <tr>
              <td>Name</td>
              <td>Nº Members</td>
              <td>Nº Admins</td>
            </tr>
          </thead>
          <tbody>
            {this.state.departments &&
                this.state.departments.map(function(d){
                return(
                  <tr key={"department_"+d.id}>
                    <td>
                      <Link to={"/companies/"+d.company.id+"/department/"+d.id}>
                        {d.name}
                      </Link>
                    </td>
                    <td>{d.n_members}</td>
                    <td>{d.n_admins}</td>
                  </tr>
                )
            })}
          </tbody>
        </Table>
      </React.Fragment>
    );
  }

  requestDepartments() {
    this.handleResponse = this.handleResponse.bind(this)
    const company_id = this.props.company_id
    request.get("/companies/"+company_id+"/departments")
      .set("Content-Type", "application/json")
      .set("Authorization", "Bearer: "+this.props.user.jwt)
      .end(this.handleResponse)
  }

  handleResponse(err, res) {
    if(!err) {
      const json_departments = res.body.departments
      const departments = JSON.parse(json_departments)
      this.setState({departments: departments})
    }
  }
}

DepartmentsTable.defaultProps = {
  departments: []
}

DepartmentsTable.propTypes = {
  departments: PropTypes.arrayOf(types.department_shape)
}

var conn_comp = connectToUser(DepartmentsTable)
conn_comp = withRouter(conn_comp)
export default conn_comp
