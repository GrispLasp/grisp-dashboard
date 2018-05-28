import { createStore, applyMiddleware  } from 'redux';
import { createLogger } from 'redux-logger'
import reducers from './reducers';
import thunkMiddleware from 'redux-thunk';
const middlewareLogger = createLogger()

let store;
store = createStore(reducers,window.__REDUX_DEVTOOLS_EXTENSION__ && window.__REDUX_DEVTOOLS_EXTENSION__(), applyMiddleware(thunkMiddleware,middlewareLogger));

export default store;
