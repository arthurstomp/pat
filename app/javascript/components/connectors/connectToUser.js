import React from "react"
import PropTypes from "prop-types"
import { connect  } from 'react-redux'

function connectToUser(Component) {
  class UserConnectedComponent extends React.Component {
    render() {
      return <Component {...this.props} {...this.state}/>
    }
  }

  const mapStateToProps = state => ({
    user: state.user
  })

  const mapDispatchToProps = dispatch => ({
    setUser: user => dispatch({type: "SET_USER", user}),
    logout: () => dispatch({type: "LOGOUT"})
  })

  return connect(mapStateToProps, mapDispatchToProps)( UserConnectedComponent )
}

export default connectToUser
