import React from "react"
import PropTypes from "prop-types"
import { withRouter } from "react-router-dom"
import { 
  Navbar,
  Nav,
  NavDropdown,
  Button,
  Alert,
  Collapse
} from "react-bootstrap"
import {
  connectToErrors
} from "./connectors"
import UserNavbarBtn from "./shared/UserNavbarBtn"

class Patbar extends React.Component {
  render () {
    const showErrors = this.props.errors.length != 0

    this.clearErrors = this.clearErrors.bind(this)
    if(showErrors) {
      setTimeout(this.clearErrors, 3000)
    }
    return (
      <React.Fragment>
        <Navbar id="patbar"
          className="navi-blue-bg"
          expand="lg"
          collapseOnSelect={true}>
          <Navbar.Brand as="h1">Test</Navbar.Brand>
          <Navbar.Toggle aria-controls="basic-navbar-nav" />
          <Navbar.Collapse id="basic-navbar-nav">
            <UserNavbarBtn/>
          </Navbar.Collapse>
        </Navbar>
        <Alert
          id="errors-list"
          show={showErrors}
          dismissible={true}
          closeLabel="X"
          onClose={this.clearErrors}
          variant="danger">
          <ul>
            {this.props.errors.map(function(e) {
              return <li>{e}</li>
            })}
          </ul>
        </Alert>
      </React.Fragment>
    );
  }

  clearErrors() {
    this.props.clearErrors()
  }
}

Navbar.propTypes = {
  title: PropTypes.string
};
export default withRouter(connectToErrors(Patbar))
