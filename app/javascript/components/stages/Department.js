import React from "react"
import PropTypes from "prop-types"
import { Alert, Form, Button, Col } from "react-bootstrap"
import JobsTable from "../shared/JobsTable";
import {
  connectToUser,
} from "../connectors"
import request from "superagent"
class Department extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      department: null
    }
  }
  render () {
    if(!this.state.department) {
      this.requestDepartment(this.props.match.params.id)
    }

    if(this.state.success) {
      const self = this
      setTimeout(() => {
        self.setState({success: false})
      }, 2000)
    }

    this.handleChanges = this.handleChanges.bind(this)

    this.updateDepartment = this.updateDepartment.bind(this)
    return (
      <React.Fragment>
        {this.state.department && 
          <h1>{this.state.department.company} - {this.state.department.name}</h1>}
        {this.state.success &&
          <Alert variant="success">Department Updated</Alert>}
        <Form>
          <Form.Row>
            <Col>
              <Form.Control name="name"
                onChange={this.handleChanges}
                defaultValue={this.state.department ? this.state.department.name : ""}>
              </Form.Control>
            </Col>
            <Col>
              <Button onClick={this.updateDepartment}>
                Update
              </Button>
            </Col>
          </Form.Row>
        </Form>
        <h2>Members</h2>
        {this.state.department &&
            <JobsTable 
              show_name={true}
              jobs={this.state.department.members}/>}
      </React.Fragment>
    );
  }

  requestDepartment(id) {
    const company_id = this.props.match.params.company_id
    const self = this
    request.get("/companies/"+company_id+"/departments/"+id)
      .set("Content-Type", "application/json")
      .set("Authorization", "Bearer: "+this.props.user.jwt)
      .end(function(err, res){
        if(!err) {
          const department = JSON.parse(res.body.department)
          self.setState({department: department,
                        name: department.name})
        }
      })
  }

  handleChanges(e) {
		const target = e.target
		const value = target.value
		const name = target.name

		this.setState({
			[name]: value
		})
  }

  updateDepartment(e) {
    e.preventDefault()
    const id = this.props.match.params.id
    const company_id = this.props.match.params.company_id
    const self = this
    request.put("/companies/"+company_id+"/departments/"+id)
      .set("Content-Type", "application/json")
      .set("Authorization", "Bearer: "+this.props.user.jwt)
      .send({department: {name: this.state.name}})
      .end(function(err,res) {
        if(!err) {
          const department = JSON.parse(res.body.department)
          self.setState({success: true, department: department})
        } else {
          self.props.setErrors(res.body.errors)
        }
        self.forceUpdate()
      })
  }
}

var conn_comp = connectToUser(Department)

export default conn_comp
