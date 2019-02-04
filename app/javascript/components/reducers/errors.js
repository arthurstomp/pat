const errors = function(state = [], action) {
  switch(action.type) {
    case 'SET_ERRORS':
      return action.errors || []
    case 'CLEAR_ERRORS':
      return []
    default:
      return state
  }
}

export default errors
