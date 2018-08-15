import React, {PropTypes} from 'react';
import {connect} from 'react-redux'
import {fetchNodes} from '../../../actions/nodes-actions'
import _ from 'lodash'
import { Tab, Tabs, TabList, TabPanel } from 'react-tabs';


import Overview from './OverviewView';
import Light from './LightView';
import Pressure from './PressureView';
import Temperature from './TemperatureView';
import Gyro from './GyroView';
import Magnetic from './MagneticFieldView';

import 'react-tabs/style/react-tabs.scss';

class NodeView extends React.Component {
    constructor(props) {
        super(props);
        const tabs = ["overview", "temperature", "light", "pressure", "gyro", "magnetic"];
        let tabIndex = 0;
        if (this.props.location.hash !== '') {
            const hash = this.props.location.hash.substr(1, this.props.location.hash.length)
            tabIndex = tabs.indexOf(hash)
        }
        // console.log(tabIndex)
        this.state = {
            hourChartData: null,
            tabIndex: tabIndex,
            tabs: tabs,
        }
    }

    componentDidMount() {
        const {dispatch} = this.props
        let intervalId = setInterval(this.updateNodes.bind(this), 60000);
        this.setState({intervalId: intervalId});
    }

    componentWillUpdate(nextProps, nextState) {
        if (this.props.match.params.nodeName !== nextProps.match.params.nodeName) {
            this.setState({tabIndex: 0})
        }
    }

    componentDidUpdate(prevProps, prevState) {

        if(this.props.nodes){
          if(prevProps.match.params.nodeName !== this.props.match.params.nodeName
            || !_.isEqual(prevProps.nodes, this.props.nodes)){
            let nodeData = this.getNode()
            // this.generateTempData(nodeData)
          }
        }
    }

    componentWillUnmount(){
       clearInterval(this.state.intervalId);
    }

    updateNodes(){
      console.log("update nodes!")
      const {dispatch} = this.props
      dispatch(fetchNodes())
    }

    getNode(){
      return  _.find(this.props.nodes, (function(n) {
          return n.name === this.props.match.params.nodeName
      }).bind(this));
    }



    changeTab = (index, lastIndex, e) => {
        this.props.history.push("#" + this.state.tabs[index])
        this.setState({tabIndex: index})
    }


    render() {
        const {nodes} = this.props

        // console.log(nodes)
        let node;
        if (nodes) {
            node = this.getNode()
        }

        return (<div id="main">

                   <div className="main-container">


                      <Tabs onSelect={this.changeTab} selectedIndex={this.state.tabIndex}>
                                          <TabList>
                                              <Tab>Overview </Tab>
                                              <Tab>Temperature</Tab>
                                              <Tab>Light</Tab>
                                              <Tab>Pressure</Tab>
                                              <Tab>Gyro</Tab>
                                              <Tab>Magnetic Field</Tab>
                                          </TabList>

                                          <TabPanel>
                                              <Overview node={node}/>
                                          </TabPanel>

                                          <TabPanel>
                                              <Temperature node={node}/>
                                          </TabPanel>

                                          <TabPanel>
                                              <Light node={node}/>
                                          </TabPanel>

                                          <TabPanel>
                                              <Pressure node={node}/>
                                          </TabPanel>

                                          <TabPanel>
                                              <Gyro node={node}/>
                                          </TabPanel>

                                          <TabPanel>
                                              <Magnetic node={node}/>
                                          </TabPanel>


                                      </Tabs>


                            {/* {JSON.stringify(node, null, 2)} */}

                        </div>


        </div>);
    }
}

const mapStateToProps = (state, ownProps) => {
    // console.log(state);
    const {nodesReq, isFetching} = state.nodesReducer
    return {nodes: nodesReq.nodes, lastPingTime: nodesReq.lastPingTime}
}

const NodeContainer = connect(mapStateToProps)(NodeView)

export default NodeContainer
