export const RESET_NODES_DATA = 'RESET_NODES_DATA'
export const REQUEST_NODES = 'REQUEST_NODES'
export const RECEIVE_NODES = 'RECEIVE_NODE'
export const INVALIDATE_NODES= 'INVALIDATE_NODES'

import Config from '../config'


export const resetNodesData = () => {
    return {
        type: RESET_NODES_DATA
    };
};
 
export function invalidateNodes() {
  return {
    type: INVALIDATE_NODES
  }
}
 
function requestNodes() {
  return {
    type: REQUEST_NODES
  }
}

 
function receiveNodes(json) {
  return {
    type: RECEIVE_NODES,
    nodes: json.nodes.map(node => node),
    lastPingTime: json.last_ping_time
  }
}


export function fetchNodes() {
  return dispatch => {
    dispatch(requestNodes())
    return fetch(`${Config.getEndpoint()}/nodes`)
      .then(response => response.json())
      .then(json => {dispatch(receiveNodes(json))})
  }
}

function shouldFetchNodes(state) {

  const nodes = state.nodesReducer.items
  if (!nodes) {
    return true
  } else if (nodes.isFetching) {
    return false
  } else {
    return nodes.didInvalidate
  }
}
 
export function fetchNodesIfNeeded() {
  return (dispatch, getState) => {
    if (shouldFetchNodes(getState())) {
      return dispatch(fetchNodes())
    }
  }
}
