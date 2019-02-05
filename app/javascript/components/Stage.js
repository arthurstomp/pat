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
  CreateJob
} from "./stages"
import { Element } from "react-scroll"

import protect from "./protect"

class Stage extends React.Component {
  render () {
    return (
      <React.Fragment>
        <Col id="stage" md={9}>
          <Element>
            <Route path="/" exact component={protect(Profile)}/>
            <Route path="/login" component={Login}/>
            <Route path="/companies/:company_id/department/:id" exact
              component={protect(Department)} />
            <Route path="/companies" exact component={protect(Companies)} />
            <Route path="/company/:id" exact component={protect(Company)} />
            <Route path="/jobs" component={protect(Jobs)} />
            <Route path="/job" exact component={protect(CreateJob)} />
            <Route path="/job/:id" component={protect(Job)} />
          </Element>
        </Col>
      </React.Fragment>
    );
  }
}

export default Stage
