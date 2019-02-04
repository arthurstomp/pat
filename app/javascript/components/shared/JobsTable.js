import React from "react"
import PropTypes from "prop-types"
import types from "../prop_types"
import { Table } from "react-bootstrap"
import request from "superagent"
import { connectToUser } from "../connectors"
import { Link } from "react-router-dom"

class JobsTable extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      jobs: this.props.jobs
    }
  }
  render () {
    if(!this.state.jobs) {
      this.requestJobs()
    }
    const self = this
    return (
      <React.Fragment>
        <Table striped>
          <thead>
            <tr>
              {this.props.show_name && <td>Name</td>}
              <td>Company</td>
              <td>Role</td>
              <td>Department</td>
              <td>Salary($)</td>
            </tr>
          </thead>
          <tbody>
            {this.state.jobs && this.state.jobs.map(function(j){
              return(
                <tr key={"job_"+j.id}>
                  {self.renderLinks(j)}
                  <td>{j.role}</td>
                  <td>{j.department.name}</td>
                  <td>$ {j.salary}</td>
                </tr>
              )
            })}
          </tbody>
        </Table>
      </React.Fragment>
    );
  }

  renderLinks(j) {
    if(this.props.show_name) {
      return(
        <React.Fragment>
          <td>
            <Link to={"/job/"+j.id}>{ j.name }</Link>
          </td>
          <td>
            {j.company.name}
          </td>
        </React.Fragment>
      )
    } else {
      return(<td><Link to={"/job/"+j.id}>{j.company.name}</Link></td>)
    }
  }

  requestJobs() {
    this.handleResponse = this.handleResponse.bind(this)
    request.get("/jobs")
      .set("Content-Type", "application/json")
      .set("Authorization", "Bearer: "+this.props.user.jwt)
      .end(this.handleResponse)
  }

  handleResponse(err, res) {
    if(res.status == 200 && this.state.jobs == undefined) {
      const jobs = JSON.parse(res.body.jobs)
      this.setState({jobs: jobs})
    }
  }
}

export default connectToUser(JobsTable)
