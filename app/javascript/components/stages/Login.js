import React from "react"
import PropTypes from "prop-types"
import { withRouter } from "react-router-dom"
import { connectToErrors } from "../connectors"

import UserForm from "../UserForm"
class Login extends React.Component {
  render () {
    this.redirectToProfile = this.redirectToProfile.bind(this)
    return (
      <React.Fragment>
        <h1>Login</h1>
        <UserForm 
          route="users/login"
          method="POST"
          submitBtn="Login"
          onUpdateUserState={this.redirectToProfile}/>
      </React.Fragment>
    );
  }

  redirectToProfile (err, res) {
    console.log('err', err)
    console.log('res', res)
    if(res.status != 200) {
      this.props.setErrors(res.body)
    }
    this.props.history.push('/')
  }
}

export default withRouter(connectToErrors(Login))
