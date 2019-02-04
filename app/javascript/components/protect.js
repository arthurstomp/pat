import React from "react"
import PropTypes from "prop-types"
import { Redirect } from "react-router-dom"
import { connectToUser } from "./connectors"

function protect(Component) {
  class ProtectedComponent extends React.Component {
    render() {
      if(this.props.user.jwt) {
        return <Component {...this.props} {...this.state}/>
      } else {
        return (
          <Redirect to={{ pathname: "/login",
            state: { from: this.props.location }}}/>
        )
      }
    }
  }

  return connectToUser(ProtectedComponent)
}

export default protect
