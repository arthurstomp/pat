//const initialState = {
  //email: "test@test.com",
  //username: "teste",
  //jwt: "eyJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6InRlc3RAdGVzdC5jb20iLCJ1c2VybmFtZSI6InRlc3RlIn0.i7jnYUBQOZ1fa77ZOWR5IpFY8jZvGUZQxG7CCtBWHLc"
//}
const initialState = {}
const user = function(state = initialState, action) {
  switch(action.type) {
    case 'SET_USER':
      return Object.assign(state, action.user)
    case 'LOGOUT':
      return {}
    default:
      return state
  }
}

export default user
