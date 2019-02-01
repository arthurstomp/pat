import React from "react"
import PropTypes from "prop-types"
import { withRouter } from "react-router-dom"
import { Navbar, Nav, NavDropdown, Button } from "react-bootstrap"
import UserNavbarBtn from "./UserNavbarBtn"
class Patbar extends React.Component {
  render () {
    return (
      <Navbar id="patbar" className="navi-blue-bg" collapseOnSelect={true}>
        <Navbar.Brand href="#home">Test</Navbar.Brand>
        <Navbar.Toggle aria-controls="basic-navbar-nav" />
        <Navbar.Collapse id="basic-navbar-nav">
          <UserNavbarBtn/>
        </Navbar.Collapse>
      </Navbar>
    );
  }
}

Navbar.propTypes = {
  title: PropTypes.string
};
export default withRouter(Patbar)
