import React, {PropTypes} from 'react';
import Config from '../../../../config'
import {connect} from 'react-redux'
import {fetchNodesIfNeeded} from '../../../../actions/nodes-actions'
import moment from 'moment'


class SidebarView extends React.Component {
    constructor(props) {
        super(props);
    }

    goToUrl = (e, url) => {
      e.preventDefault();
      this.props.history.push(url);
    }

    componentDidMount() {
        const {dispatch} = this.props
        dispatch(fetchNodesIfNeeded())
    }


    render() {
        const {nodes, lastPingTime} = this.props
        let sortedNodes
        if (nodes) {
            sortedNodes = _.sortBy(nodes, (n) => {
                return n.name
            });
        }

        return (<div id="sidebar">
            <h1 onClick={(e) => this.goToUrl(e, '/')} style={{
                    cursor: 'pointer'
                }}>
                Cluster
            </h1>
            {
                nodes
                    ? <div style={{
                                display: 'flex',
                                flex: 1,
                                flexDirection: 'column'
                            }}>
                            <div className="sidebar-container">

                                <div className="menu-list">
                                    <ul>
                                        {
                                            sortedNodes
                                                ? sortedNodes.map((node, index) => {
                                                    return <li key={index} onClick={(e) => this.goToUrl(e, `/node/${node.name}`)}>
                                                        <a><span className={node.alive
                                                            ? "online"
                                                            : "offline"}/> {node.name.split('@')[0]}</a>
                                                    </li>
                                                })
                                                : null
                                        }
                                    </ul>
                                </div>

                            </div>
                            <div className="last-ping">
                                Last ping at:
                                <span>{moment.unix(lastPingTime / 1000000000).format("h:mm:ss a")}</span>
                            </div>
                        </div>
                    : null
            }
        </div>);
    }
}

const mapStateToProps = (state, ownProps) => {
    // console.log(state);
    const {nodesReq, isFetching} = state.nodesReducer
    return {nodes: nodesReq.nodes, lastPingTime: nodesReq.lastPingTime}
}

const SidebarContainer = connect(mapStateToProps)(SidebarView)

export default SidebarContainer