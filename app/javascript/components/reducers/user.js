//const initialState = {
  //email: "user1@test.com",
  //username: "user1",
  //jwt: "eyJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6InVzZXIxQHRlc3QuY29tIiwidXNlcm5hbWUiOiJ1c2VyMSJ9.7OSsLo2cHbbi2hTXRV6OUezOGbpFPer9XTDuvTPR7Pw"
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
