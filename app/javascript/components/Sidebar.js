import React from "react"
import PropTypes from "prop-types"
import { Col } from 'react-bootstrap';

class Sidebar extends React.Component {
  render () {
    return (
      <React.Fragment>
        <Col id="sidebar" className="full" md={3}>SideBar</Col>
      </React.Fragment>
    );
  }
}

export default Sidebar
