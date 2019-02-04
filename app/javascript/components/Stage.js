import React from "react"
import PropTypes from "prop-types"
import { Route, Link } from "react-router-dom";
import { Col } from 'react-bootstrap';
import {
  Profile,
  Jobs,
  Job,
  Employees,
  Department,
  Company,
  Companies,
  Login,
} from "./stages"

import protect from "./protect"

class Stage extends React.Component {
  render () {
    return (
      <React.Fragment>
        <Col id="stage" md={9}>
          <Route path="/" exact component={protect(Profile)}/>
          <Route path="/login" component={Login}/>
          <Route path="/companies" component={protect(Companies)} />
          <Route path="/company/:id" component={protect(Company)} />
          <Route path="/companies/:company_id/department/:id"
            component={protect(Department)} />
          <Route path="/jobs" component={protect(Jobs)} />
          <Route path="/job/:id" component={protect(Job)} />
        </Col>
      </React.Fragment>
    );
  }
}

export default Stage
