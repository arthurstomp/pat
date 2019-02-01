import React from "react"
import PropTypes from "prop-types"
import types from "../../prop_types"
import { Form, Button } from "react-bootstrap"

class UserSettingsForm extends React.Component {
  render () {
    return (
      <React.Fragment>
        <h2>User settings</h2>
        <Form>
          <Form.Group controlId="email">
            <Form.Label>Email</Form.Label>
            <Form.Control type="email" placeholder={this.props.user.email}/>
          </Form.Group>
          <Form.Group controlId="username">
            <Form.Label>Username</Form.Label>
            <Form.Control placeholder={this.props.user.username}/>
          </Form.Group>
          <Button variant="primary" type="submit">
            Update
          </Button>
        </Form>
      </React.Fragment>
    );
  }
}

UserSettingsForm.defaultProps = {
  user: {email: "", username: ""}
}

UserSettingsForm.propTypes = {
  user: types.user_shape
}

export default UserSettingsForm
