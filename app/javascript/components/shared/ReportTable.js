import React from "react"
import PropTypes from "prop-types"

import { Table } from "react-bootstrap"
import request from "superagent"
import { connectToUser } from "../connectors"
import { Link } from "react-router-dom"

class ReportTable extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      data: null
    }
  }

  render () {
    if(this.state.data === null) {
      this.requestReport()
    }
    return (
      <React.Fragment>
        <Table striped>
          <thead>
            <tr>
              <td>Name</td>
              <td>Role</td>
              <td>Salary($)</td>
              <td>Company</td>
              <td>Department</td>
            </tr>
          </thead>
          <tbody>
            {this.state.data &&
                this.state.data.map(function(j) {
                  return(
                    <tr key={"job_"+j.id}>
                      <td>
                        <Link to={"/job/"+j.id}>{ j.name }</Link>
                      </td>
                      <td>{ j.role }</td>
                      <td>{ j.salary }</td>
                      <td>{ j.company }</td>
                      <td>{ j.department }</td>
                    </tr>
                  )
                })}
              </tbody>
        </Table>
      </React.Fragment>
    );
  }

  requestReport() {
    this.handleResponse = this.handleResponse.bind(this)
    request.get("/companies/"+ this.props.company_id + "/report")
      .set("Content-Type", "application/json")
      .set("Authorization", "Bearer: "+this.props.user.jwt)
      .end(this.handleResponse)
  }

  handleResponse(err, res) {
    if(res.status == 200) {
      var report_jobs = res.body.report_jobs
      this.setState({data: report_jobs})
      this.forceUpdate()
    }
  }
}

export default connectToUser(ReportTable)
