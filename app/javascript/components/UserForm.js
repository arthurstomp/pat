import React from "react"
import PropTypes from "prop-types"
import types from "./prop_types"
import { Form, Button } from "react-bootstrap"
import request from "superagent"
import { connect  } from 'react-redux'
import {
  connectToUser,
  connectToErrors
} from "./connectors"

class UserForm extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      email: "",
      username: ""
    }
  }

  render () {
    return this.renderForm()
  }

	handleChanges(e) {
		const target = e.target
		const value = target.value
		const name = target.id

		this.setState({
			[name]: value
		})
	}

  renderForm() {
		this.handleChanges = this.handleChanges.bind(this)
    const email = this.props.user.email || null
    const username = this.props.user.username || null
    return (
      <React.Fragment>
        <Form>
          <Form.Group controlId="email">
            <Form.Label>Email</Form.Label>
            <Form.Control type="email"
              placeholder="Email"
              defaultValue={email}
              size="sm"
              onChange={this.handleChanges}/>
          </Form.Group>
          <Form.Group controlId="username">
            <Form.Label>Username</Form.Label>
            <Form.Control 
              placeholder="Username" 
              defaultValue={username}
              size="sm"
              onChange={this.handleChanges}/>
          </Form.Group>
          <Button onClick={this.submitAction()}variant="primary" type="submit">
            { this.props.submitBtn }
          </Button>
        </Form>
      </React.Fragment>
    );
  }

  submitAction() {
    this.updateUserState = this.updateUserState.bind(this)
    switch(this.props.method){
      case "POST":
        this.performLogin = this.performLogin.bind(this)
        return this.performLogin
      case "PUT":
      case "PATCH":
        this.performUpdate = this.performUpdate.bind(this)
        return this.performUpdate
    }
  }

  performLogin(e) {
    e.preventDefault()
    request
      .post(this.props.route)
      .set("Content-Type", "application/json")
      .send({user: {email: this.state.email, username: this.state.username}})
      .end(this.updateUserState)
  }

  performUpdate(e) {
    e.preventDefault()
    request
      .put(this.props.route)
      .set("Content-Type", "application/json")
      .set("Authorization", "Bearer: "+this.props.user.jwt)
      .send({user: {email: this.state.email, username: this.state.username}})
      .end(this.updateUserState)
  }

  updateUserState(err, res) {
    if(err) {
			this.props.setErrors(res.body)
      this.setState({
        errors: res.body
      })
    } else {
			this.props.setUser(res.body)
      this.setState({
        user: res.body
      })
    }
    this.props.onUpdateUserState(err, res)
  }
}

UserForm.defaultProps = {
  route: "/",
  submitBtn: "Update",
  onUpdateUserState: function(errors) {}
}

UserForm.propTypes = {
  route: PropTypes.string,
  submitBtn: PropTypes.string,
  onUpdateUserState: PropTypes.func
}

const mapStateToProps = state => ({
})

const mapDispatchToProps = dispatch => ({
})

var conn_comp = connectToUser(UserForm)
conn_comp = connectToErrors(conn_comp)

export default connect(mapStateToProps, mapDispatchToProps)(conn_comp)
