import { combineReducers } from 'redux'
import user from './user'
import errors from './errors'
import companies from './companies'

export default combineReducers({
  user,
  errors,
  companies,
})

