import React from "react"
import PropTypes from "prop-types"
import types from "../prop_types"
import { Table } from "react-bootstrap"

class DepartmentsTable extends React.Component {
  render () {
    return (
      <React.Fragment>
        <h2>Departments</h2>
        <Table>
          <thead>
            <tr>
              <td>Company</td>
              <td>Name</td>
              <td>Nº Employees</td>
            </tr>
          </thead>
          <tbody>
            {this.props.departments &&
                this.props.departments.map(function(d){
                return(
                  <tr>
                    <td>{d.company}</td>
                    <td>{d.name}</td>
                    <td>{d.n_employees}</td>
                  </tr>
                )
            })}
          </tbody>
        </Table>
      </React.Fragment>
    );
  }
}

DepartmentsTable.defaultProps = {
  departments: []
}

DepartmentsTable.propTypes = {
  departments: PropTypes.arrayOf(types.department_shape)
}

export default DepartmentsTable
