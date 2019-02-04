import React from "react"
import PropTypes from "prop-types"
import { connect  } from 'react-redux'

function connectToCompanies(Component) {
  class CompaniesConnectedComponent extends React.Component {
    render() {
      return <Component {...this.props} {...this.state}/>
    }
  }

  const mapStateToProps = state => ({
    companies: state.companies
  })

  const mapDispatchToProps = dispatch => ({
    setCompanies: companies => dispatch({type: "SET_COMPANIES", companies}),
    pushCompany: company => dispatch({type: "PUSH_COMPANY", company}),
    deleteCompany: id => dispatch({type: "DELETE_COMPANY", id})
  })

  return connect(mapStateToProps, mapDispatchToProps)( CompaniesConnectedComponent )
}

export default connectToCompanies
