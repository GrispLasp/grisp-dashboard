import {combineReducers} from 'redux'

import nodesReducer from './nodes-reducer'


const app = combineReducers({
  nodesReducer
})

export default app
