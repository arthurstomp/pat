import React from "react"
import PropTypes from "prop-types"
import { Route, Link } from "react-router-dom";
import { Col } from 'react-bootstrap';
import {
  Profile,
  Jobs,
  Job,
  Employees,
  Departments
} from "./stages"

class Stage extends React.Component {
  render () {
    const Index = () => <h2>Home</h2>;
    const About = () => <h2>About</h2>;
    const Users = () => <h2>Users</h2>;
    return (
      <React.Fragment>
        <Col id="stage" md={9}>
          <Route path="/" component={Profile}/>
          <Route path="/jobs" component={Jobs} />
          <Route path="/jobs/:id" component={Job} />
          <Route path="employees/:structure/:id" component={Employees}/>
          <Route path="departments/:company_id" component={Departments}/>
          <Link to="/about">About</Link>
        </Col>
      </React.Fragment>
    );
  }
}

export default Stage
