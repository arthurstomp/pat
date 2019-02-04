const companies = function(state = {}, action) {
  switch(action.type) {
    case 'SET_COMPANIES':
      var s = {}
      const companies = JSON.parse(action.companies)
      companies.forEach(function(company) {
        s[company.id] = company
      })
      return Object.assign(state, s)
    case 'PUSH_COMPANY':
      const company = JSON.parse(action.company)
      return Object.assign(state, {[ company.id ]: company})
    case 'LOGOUT':
      return Object.assign(state, {[ action.id ]: null})
    case 'COMPANY':
      return
    default:
      return state
  }
}

export default companies
