import React from "react"
import PropTypes from "prop-types"
import ReactDOM from 'react-dom'

import { Provider } from 'react-redux'
import { createStore } from 'redux'
import rootReducer from './reducers'

const store = createStore(rootReducer)

import App from './App'

class ReduxAppWrapper extends React.Component {
	render () {
		const rootElement = document.getElementById('root')
		return (
			<Provider store={store}>
				<App title={this.props.title}/>
			</Provider>
		)
	}
}

ReduxAppWrapper.propTypes = {
	title: PropTypes.string
};
export default ReduxAppWrapper
