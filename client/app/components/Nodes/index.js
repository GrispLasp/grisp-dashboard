import React, {PropTypes} from 'react';
import Plot from 'react-plotly.js';
import _ from 'lodash'
import {connect} from 'react-redux'

class NodesView extends React.Component {
  constructor(props) {
    super(props);
    console.log(props)
    this.state = {
        scatterPlot: null
    }
  }

  componentDidMount() {
  }


  // componentDidUpdate(prevProps, prevState) {
  //     if (this.props.node) {
  //         if (!_.isEqual(prevProps.node, this.props.node)) {
  //             this.generateScatterPlot(this.props.node.als_state)
  //         }
  //     }
  // }

  generateScatterPlot = (nodesData) => {

      let colors = ['rgb(215,48,39)','rgb(69,117,180)']

      let data = nodesData.map((node, index) => {
        return {
            x: node.als_state.data.xs,
            y: node.als_state.data.ys,
            type: 'scatter',
            mode: 'markers',
            name: node.name,
            marker: {color: colors[index]},
        };
      });

      let layout = {
          title: 'Scatter Plot'
      };
      let res = {data: data, layout: layout}

      this.setState({scatterPlot: res})

  }

  render() {
    const {nodes} = this.props;
    console.log(nodes)
    if (nodes && !this.state.scatterPlot) {
        this.generateScatterPlot(nodes)
    }
    return (<div id="main">

               <div className="main-container">

      <h1>
          Ambient light Regression
      </h1>

        {
            nodes && this.state.scatterPlot
                ? <div>

                  <div className="charts-container">

                      <div className="charts">
                        <Plot data={this.state.scatterPlot.data}
                           layout={this.state.scatterPlot.layout}/>
                      </div>
                  </div>



                    </div>
                : null
        }

    </div>
  </div>);
  }
}

const mapStateToProps = (state, ownProps) => {
    // console.log(state);
    const {nodesReq, isFetching} = state.nodesReducer
    return {nodes: nodesReq.nodes, lastPingTime: nodesReq.lastPingTime}
}

const NodesContainer = connect(mapStateToProps)(NodesView)

export default NodesContainer
