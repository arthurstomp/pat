import React from "react"
import PropTypes from "prop-types"
import { connect  } from 'react-redux'

function connectToErrors(Component) {
  class ErrorConnectedComponent extends React.Component {
    render() {
      return <Component {...this.props} {...this.state}/>
    }
  }

  const mapStateToProps = state => ({
    errors: state.errors
  })

  const mapDispatchToProps = dispatch => ({
    setErrors: errors => dispatch({type: "SET_ERRORS", errors}),
    clearErrors: () => dispatch({type: "CLEAR_ERRORS"})
  })

  return connect(mapStateToProps, mapDispatchToProps)(ErrorConnectedComponent)
}

export default connectToErrors
