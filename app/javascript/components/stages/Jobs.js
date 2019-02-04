import React from "react"
import PropTypes from "prop-types"

import JobsTable from "../shared/JobsTable"
class Jobs extends React.Component {
  render () {
    return (
      <React.Fragment>
        <h1>Jobs</h1>
        <JobsTable/>
      </React.Fragment>
    );
  }
}

export default Jobs
