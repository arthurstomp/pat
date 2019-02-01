import React from "react"
import PropTypes from "prop-types"
import { BrowserRouter as Router} from "react-router-dom";
import { Container, Row, Col } from 'react-bootstrap';
import Stage from "./Stage";
import Patbar from "./Patbar"
import Sidebar from "./Sidebar"

class App extends React.Component {
  render () {
    return (
      <Router>
        <div>
          <Patbar title={this.props.title} />
          <Container id="theather" className="full" fluid={true}>
            <Row className="full">
              <Sidebar/>
              <Stage/>
            </Row>
          </Container>
        </div>
      </Router>
    );
  }
}

App.propTypes = {
  title: PropTypes.string
};
export default App
