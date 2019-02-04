import React from "react"
import PropTypes from "prop-types"

import JobForm from "../shared/JobForm"
class Job extends React.Component {
  render () {
    return (
      <React.Fragment>
        <h1>Job</h1>
        <JobForm 
          id={this.props.match.params.id} />
      </React.Fragment>
    );
  }
}

export default Job
