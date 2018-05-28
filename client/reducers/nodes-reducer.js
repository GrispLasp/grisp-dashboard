import {combineReducers} from 'redux'

import {
    RESET_NODES_DATA,
    INVALIDATE_NODES,
    REQUEST_NODES,
    RECEIVE_NODES
} from '../actions/nodes-actions'

function nodes(state = {
    isFetching: false,
    didInvalidate: false,
    items: []
}, action) {
    switch (action.type) {
        case INVALIDATE_NODES:
            return Object.assign({}, state, {didInvalidate: true})
        case REQUEST_NODES:
            return Object.assign({}, state, {
                isFetching: true,
                didInvalidate: false
            })
        case RECEIVE_NODES:
            return Object.assign({}, state, {
                isFetching: false,
                didInvalidate: false,
                nodes: action.nodes,
                lastPingTime: action.lastPingTime
            })
        default:
            return state
    }
}

function nodesReq(state = {}, action) {

    switch (action.type) {
        case RESET_NODES_DATA:
            return {}
        case INVALIDATE_NODES:
        case RECEIVE_NODES:
        case REQUEST_NODES:
            return nodes(state, action)
        default:
            return state
    }
}



const icosReducer = combineReducers({nodesReq})

export default icosReducer
