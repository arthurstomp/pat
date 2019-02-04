import React from "react"
import PropTypes from "prop-types"
import { Row, Container, Col, ListGroup } from 'react-bootstrap';
import { Link } from "react-router-dom"

class Sidebar extends React.Component {
  render () {
    return (
      <React.Fragment>
        <Col id="sidebar" className="full" md={3}>
          <Container>
            <ListGroup>
              <ListGroup.Item>
                <Row>
                  <Link to="/companies">Companies</Link>
                </Row>
                <Row>
                  <Link to="/jobs">Jobs</Link>
                </Row>
              </ListGroup.Item>
            </ListGroup>
          </Container>
        </Col>
      </React.Fragment>
    );
  }
}

export default Sidebar
