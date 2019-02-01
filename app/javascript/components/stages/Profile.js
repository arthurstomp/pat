import React from "react";
import PropTypes from "prop-types";

import UserSettingsForm from "./profile/UserSettingsForm";
import JobsTable from "../shared/JobsTable";
import CompaniesTable from "../shared/CompaniesTable";

class Profile extends React.Component {
  render () {
    return (
      <React.Fragment>
        <h1>Profile</h1>
        <UserSettingsForm />
        <h3>user settings form</h3>
        <h3>best paying jobs</h3>
        <h3>Owned companies</h3>
      </React.Fragment>
    );
  }
}

Profile.propTypes = {
  user: PropTypes.shape({
    email: PropTypes.string,
    username: PropTypes.string,
  }),

  jobs: PropTypes.arrayOf(PropTypes.shape({
    company: PropTypes.string,
    department: PropTypes.string,
    salary: PropTypes.float
  })),

  companies: PropTypes.arrayOf(PropTypes.shape({
    name: PropTypes.string,
    n_departments: PropTypes.string,
    n_employees: PropTypes.float
  }))
}

export default Profile
