import React from "react";
import PropTypes from "prop-types";

import UserForm from "../UserForm";
import { Alert } from "react-bootstrap"

class Profile extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      success: false
    }
  }

  render () {
    this.resetSuccess = this.resetSuccess.bind(this)
    this.handleResponse = this.handleResponse.bind(this)
    if(this.state.success) {
      setTimeout(this.resetSuccess, 2000)
    }
    return (
      <React.Fragment>
        <h1>Profile</h1>
        <Alert
          show={this.state.success}
          variant="success"
          onClose={this.resetSuccess}>
          User updated.
        </Alert>
        <UserForm
          route="/users"
          method="PUT"
          submitBtn="Update"
          onUpdateUserState={this.handleResponse}/>
      </React.Fragment>
    );
  }

  handleResponse(err,res) {
    if(res.status == 200) {
      this.setState({success: true})
    }
  }

  resetSuccess() {
    this.setState({success: false})
  }
}

export default Profile
