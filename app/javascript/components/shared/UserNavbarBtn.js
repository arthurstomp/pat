import React from "react"
import PropTypes from "prop-types"
import { Nav, NavDropdown, Button } from "react-bootstrap"
import { Link } from "react-router-dom";
import { withRouter } from "react-router-dom"
import types from "../prop_types"
import { connectToUser } from "../connectors"

class UserNavbarBtn extends React.Component {
  render () {
    return (
      <React.Fragment>
        <Nav id="user-nav" className="ml-auto">
          {this.props.user.jwt && this.renderUserDropdown(this.props.user)}
          {!this.props.user.jwt && this.renderLoginBtn()}
        </Nav>
      </React.Fragment>
    );
  }

  goToProfile() {
    this.props.history.push('/')
  }

  logout() {
    console.log("logout")
    this.props.logout()
  }

  goToLogin() {
    this.props.history.push('/login')
  }

  renderUserDropdown(user) {
    this.goToProfile = this.goToProfile.bind(this)
    this.logout = this.logout.bind(this)

    return (
      <NavDropdown title="UserNav" id="basic-nav-dropdown">
        <NavDropdown.Item onClick={this.goToProfile}>
          Profile
        </NavDropdown.Item>
        <NavDropdown.Divider />
        <NavDropdown.Item onClick={this.logout}>
          Log out!
        </NavDropdown.Item>
      </NavDropdown>
    )
  }

  renderLoginBtn() {
    this.goToLogin = this.goToLogin.bind(this)
    return (
      <Nav.Item>
        <Button onClick={this.goToLogin}>
          Login
        </Button>
      </Nav.Item>
    )
  }
}

UserNavbarBtn.defaultProps = {
  user: null,
}

UserNavbarBtn.propTypes = {
  user: types.user_shape,
}

export default withRouter(connectToUser(UserNavbarBtn))
