import React from "react"
import PropTypes from "prop-types"

import JobForm from "../shared/JobForm"
class CreateJob extends React.Component {
  render () {
    return (
      <React.Fragment>
        <h1>Job</h1>
        <JobForm job={{}} create={true}/>
      </React.Fragment>
    );
  }
}

export default CreateJob
