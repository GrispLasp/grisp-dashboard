import React, {PropTypes} from 'react';
import {connect} from 'react-redux'
import {fetchNodes} from '../../../actions/nodes-actions'
import _ from 'lodash'
import {ResponsiveLine} from '@nivo/line'

class NodeView extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            hourChartData: null
        }
    }

    componentDidMount() {
        const {dispatch} = this.props
        let intervalId = setInterval(this.updateNodes.bind(this), 10000);
        this.setState({intervalId: intervalId});
    }


    componentDidUpdate(prevProps, prevState) {

        if(this.props.nodes){
          if(prevProps.match.params.nodeName !== this.props.match.params.nodeName
            || !_.isEqual(prevProps.nodes, this.props.nodes)){
            let nodeData = this.getNode()
            this.generateTempData(nodeData)
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

    generateTempData(nodeData) {

        // console.log(nodeData)

        let steps = nodeData.hour_data.map((hourTemp, index) => {
            return {x: index, y: hourTemp}
        })
        // console.log(steps)

        let chartData = {
            data: steps
        }

        this.setState({currentNode: nodeData.name, hourChartData: [chartData]})

    }

    render() {
        const {nodes} = this.props

        // console.log(nodes)
        let node;
        if (nodes) {
            node = this.getNode()
            if(node && !this.state.hourChartData){
              this.generateTempData(node)
            }

        }

        return (<div id="main">
            {
                node && this.state.hourChartData
                    ? <div className="main-container">

                            <h1>
                                Node
                            </h1>
                            {/* {JSON.stringify(node, null, 2)} */}

                            <p>Distributed node name: <b>{node.name}</b></p>
                            <p>Average temperature : <b>{node.avg.toFixed(2)} °C</b></p>
                            <p>Hours passed: <b>{node.counter}h</b></p>


                            <div className="chart-title"> Temperature/hour chart</div>
                            <div className="charts">
                                <ResponsiveLine data={this.state.hourChartData} curve="natural" margin={{
                                        "top" : 50,
                                        "right" : 110,
                                        "bottom" : 50,
                                        "left" : 60
                                    }} minY="auto" stacked={true} axisBottom={{
                                        "orient" : "bottom",
                                        "tickSize" : 5,
                                        "tickPadding" : 5,
                                        "tickRotation" : 0,
                                        "legend" : "hour",
                                        "legendOffset" : 36,
                                        "legendPosition" : "center"
                                    }} axisLeft={{
                                        "orient" : "left",
                                        "tickSize" : 5,
                                        "tickPadding" : 5,
                                        "tickRotation" : 0,
                                        "legend" : "temperature",
                                        "legendOffset" : -40,
                                        "legendPosition" : "center"
                                    }} dotSize={10} colors="pastel1" dotColor="inherit:darker(0.3)" dotBorderWidth={2} dotBorderColor="#ffffff" enableDotLabel={true} dotLabel="y" dotLabelYOffset={-12} animate={true} motionStiffness={90} motionDamping={15} legends={[{
                                            "anchor": "bottom-right",
                                            "direction": "column",
                                            "translateX": 100,
                                            "itemWidth": 80,
                                            "itemHeight": 20,
                                            "symbolSize": 12,
                                            "symbolShape": "circle"
                                        }
                                    ]}/>
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

const NodeContainer = connect(mapStateToProps)(NodeView)

export default NodeContainer
